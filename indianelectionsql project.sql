 Select * from constituencywise_details;
 Select * from constituencywise_results;
 select * from partywise_results;
 select * from states;
 Select * from statewise_results;
----Total no of MP seats in India 
select 
Distinct COUNT(parliament_constituency) AS Total_Parliament_Seats
from constituencywise_results

---- total no of seats avalilable for elections in each state
select 
 COUNT(constituencywise_results.Parliament_Constituency) AS Total_Parliament_Seats_by_State,  states.State  as State_name
from constituencywise_results
 inner join statewise_results
on   constituencywise_results.parliament_constituency= statewise_results.parliament_constituency
inner join states
on states.State_ID = statewise_results.State_ID
group by states.State;

---total seats won by NDA Alliance
.
 
 select 
 SUM(case
     when party in (
	      'Bharatiya Janata Party - BJP',
		  'Telugu Desam - TDP',
          'Janata Dal  (United) - JD(U)',
          'Shiva Sena - SHS',
		  'AJSU Party - AJSUP',
		  'Apna Dal (Soneylal) - ADAL',
		  'Asom Gana Parished - AGP',
		  'Hindustani Awam Morcha (Secular) - HAMS',
		  'Janasena Party - JnP',
		  'Janata Dal (Secular)-JD(S)',
		  'Lok Janshakti Party(Ram Vilas) - LJPRV',
		  'Nationalist Congress Party - NCP',
		  'Rashtriya Lok Dal - RLD',
		  'Sikkim Krantikari Morcha - SKM'
		  )
		  then [Won] Else 0
		  end) as NDA_Total_Seats_Won
		  from partywise_results;

------- total seats won by INDIA Alliance

select 
     SUM(case 
        when party in (
		        'Indian National Congress - INC',
				'Aam Aadmi Party - AAAP',
				'Communist Party of India  (Marxist) - CPI(M) ',
				'Samajwadi Party - SP',
				'All India Trinamool Congress - AITC',
				'Dravida Munnetra Kazhagam - DMK',
				'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
				'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
				'Rashtriya Janata Dal - RJD',
				'Jharkhand Mukti Morcha - JMM',
				'Communist Party of India - CPI',
				'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
				'Jammu & Kashmir National Conference - JKN',
				'Revolutionary Socialist Party - RSP',
				'Viduthalai Chiruthaigal Katchi - VCK',
				'Indian Union Muslim League - IUML',
				'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
				'Rashtriya Loktantrik Party - RLTP',
				'Marumalarchi Dravida Munnetra Kazhagam - MDMK'
				) then [Won] ELSE 0 
				end) as 'I.N.D.I.A_Total_Seats_Won'
				from partywise_results;

------- Seats won by NDA Alliences 
select 
    party as Party_Name,
	won as Seats_Won
	from
	    partywise_results
    where 
	  Party in (
	   'Bharatiya Janata Party - BJP',
		  'Telugu Desam - TDP',
          'Janata Dal  (United) - JD(U)',
          'Shiva Sena - SHS',
		  'AJSU Party - AJSUP',
		  'Apna Dal (Soneylal) - ADAL',
		  'Asom Gana Parished - AGP',
		  'Hindustani Awam Morcha (Secular) - HAMS',
		  'Janasena Party - JnP',
		  'Janata Dal (Secular)-JD(S)',
		  'Lok Janshakti Party(Ram Vilas) - LJPRV',
		  'Nationalist Congress Party - NCP',
		  'Rashtriya Lok Dal - RLD',
		  'Sikkim Krantikari Morcha - SKM'
		  )
		  order by Seats_Won DESC;

--- Seats won by INDIA allience
Select 
party as Party_Name,
Won as Seats_Won
from 
    partywise_results
	where Party in (
	      'Indian National Congress - INC',
				'Communist Party of India  (Marxist) - CPI(M) ',
				'Samajwadi Party - SP',
				'All India Trinamool Congress - AITC',
				'Dravida Munnetra Kazhagam - DMK',
				'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
				'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
				'Rashtriya Janata Dal - RJD',
				'Jharkhand Mukti Morcha - JMM',
				'Communist Party of India - CPI',
				'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
				'Jammu & Kashmir National Conference - JKN',
				'Revolutionary Socialist Party - RSP',
				'Viduthalai Chiruthaigal Katchi - VCK',
				'Indian Union Muslim League - IUML',
				'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
				'Rashtriya Loktantrik Party - RLTP',
				'Marumalarchi Dravida Munnetra Kazhagam - MDMK' )
				order by Seats_Won DESC;

---------------add new colums field in table pratywise to get the party alliance as NDA, India and Others

		     
alter table partywise_results
add Party_Alliance varchar(200); 


--India alliance
update partywise_results
set Party_Alliance = 'I.N.D.I.A'
where Party in (
        'Indian National Congress - INC',
		'Aam Aadmi Party - AAAP',
				'Communist Party of India  (Marxist) - CPI(M) ',
				'Samajwadi Party - SP',
				'Kerala Congress - KEC',
				'All India Trinamool Congress - AITC',
				'Dravida Munnetra Kazhagam - DMK',
				'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
				'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
				'Rashtriya Janata Dal - RJD',
				'Bharat Adivasi Party - BHRTADVSIP',
				'Jharkhand Mukti Morcha - JMM',
				'Communist Party of India - CPI',
				'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
				'Jammu & Kashmir National Conference - JKN',
				'Revolutionary Socialist Party - RSP',
				'Viduthalai Chiruthaigal Katchi - VCK',
				'Indian Union Muslim League - IUML',
				'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
				'Rashtriya Loktantrik Party - RLTP',
				'Marumalarchi Dravida Munnetra Kazhagam - MDMK' );

---NDA alliance 
  update partywise_results
  set Party_Alliance = 'NDA'
  where Party in (
  'Bharatiya Janata Party - BJP',
		  'Telugu Desam - TDP',
          'Janata Dal  (United) - JD(U)',
          'Shiv Sena - SHS',
		  'AJSU Party - AJSUP',
		  'Janata Dal  (Secular) - JD(S)',
		  'Apna Dal (Soneylal) - ADAL',
		  'Asom Gana Parishad - AGP',
		  'Asom Gana Parished - AGP',
		  'Hindustani Awam Morcha (Secular) - HAMS',
		  'Janasena Party - JnP',
		  'Janata Dal (Secular)-JD(S)',
		  'Lok Janshakti Party(Ram Vilas) - LJPRV',
		  'Nationalist Congress Party - NCP',
		  'Rashtriya Lok Dal - RLD',
		  'Sikkim Krantikari Morcha - SKM' );

--- others
update partywise_results
set Party_Alliance = 'Others'
where Party_Alliance is null;

Select party_Alliance,
SUM(Won) as 'Seats Won'
from partywise_results
group by Party_Alliance;

select party,
won 
from partywise_results
where Party_Alliance = 'I.N.D.I.A'
order by Won DESC

--- winning Candidate name, their party name, total votes and the margin of victory for specific state and consituency?

Select Winning_Candidate, party, Total_Votes, constituencywise_results.Margin, constituency, state
from constituencywise_results
join partywise_results
on constituencywise_results.Party_ID= partywise_results.Party_ID
join statewise_results
on constituencywise_results.Parliament_Constituency= statewise_results.Parliament_Constituency
Where constituencywise_results.Constituency_Name= 'Nizamabad';

---- distribution of evm votes versus postal votes for candidates in a specific constituency
select constituencywise_details.Candidate,constituencywise_results.Constituency_Name, constituencywise_details.EVM_Votes, constituencywise_details.Postal_Votes, constituencywise_details.Total_Votes
from constituencywise_results
join constituencywise_details
on constituencywise_results.Constituency_ID= constituencywise_details.Constituency_ID
where constituencywise_results.Constituency_Name= 'Nizamabad'
;

---parties won the most seats in a state, and how many seats each party win

select partywise_results.Party, count(constituencywise_results.Constituency_Name) as 'Seats won',   state
from partywise_results
join constituencywise_results
on partywise_results.Party_ID= constituencywise_results.Party_ID
join statewise_results
on constituencywise_results.Parliament_Constituency= statewise_results.Parliament_Constituency
where State='Rajasthan'
group by Party,State
order by State;

----total number  of seats won by each party alliance (NDA, I.N.D.I.A and Others)
-- in each state for the indian Elections 2024


select states.State, sum(Case when partywise_results.party_Alliance ='NDA' Then 1 else 0 end) as NDA_Seats_won,
                     SUM(case when partywise_results.Party_Alliance = 'I.N.D.I.A' Then 1 else 0 end) as India_Seats_Won,
					 SUM(Case when partywise_results.Party_Alliance= 'Others' Then 1 else 0 End) as Others_Seats_Won
from partywise_results
join constituencywise_results
on partywise_results.Party_ID= constituencywise_results.Party_ID
join statewise_results
on constituencywise_results.Parliament_Constituency= statewise_results.Parliament_Constituency
join states on statewise_results.State_ID= states.State_ID

group by states.State
order by State;

----candidate received the highest numbers of EVM votes in each constituency(top10)
 select top 10
 cr.Constituency_Name, cr.Constituency_ID, cd.Candidate, cd.EVM_Votes
 from constituencywise_details cd
 join constituencywise_results cr
 on cd.Constituency_ID = cr.Constituency_ID
 where cd.EVM_Votes = (
     select MAX(cd1.EVM_Votes)
	 from constituencywise_details cd1
	 where cd1.Constituency_ID= cd.Constituency_ID)
	 order by cd.EVM_Votes DESC;

---candidate won and which candidate was the runner-up in each constituency of state for the 2024 elections
with RankedCandidates as (
     select 
	       constituencywise_details.Constituency_ID, constituencywise_details.Candidate, constituencywise_details.Party, constituencywise_details.EVM_Votes, 
		   constituencywise_details.Postal_Votes, constituencywise_details.EVM_Votes + constituencywise_details.Postal_Votes as 'Total Votes',
		   ROW_NUMBER() over (PARTITION by constituencywise_details.Constituency_ID order by constituencywise_details.EVM_Votes + constituencywise_details.Postal_Votes DESC) as VoteRank
		   from
		   constituencywise_details
		   join constituencywise_results on constituencywise_details.Constituency_ID=constituencywise_results.Constituency_ID
		   join statewise_results on constituencywise_results.Parliament_Constituency=statewise_results.Parliament_Constituency
		   join states on statewise_results.State_ID=states.State_ID
		   where 
		   states.State = 'Andhra Pradesh'
		   )
Select 
constituencywise_results.Constituency_Name,
MAX(case when RankedCandidates.VoteRank = 1 then RankedCandidates.Candidate End) as Winning_Candidate,
MAX(Case When RankedCandidates.VoteRank = 2 Then RankedCandidates.Candidate end) as Runnerup_Candidate
From
 RankedCandidates
 join constituencywise_results on RankedCandidates.Constituency_ID = constituencywise_results.Constituency_ID
 group by  constituencywise_results.Constituency_Name
 order by Constituency_Name;

 ---state of Andhra Pradesh, what are the total number of seats, total number of candidates, total number of parties, total votes(including evm and postal), and the breakdown of evm and postal votes

 Select 
        Count(Distinct constituencywise_results.Parliament_Constituency) as 'Total Constituencies',
        COUNT(Distinct constituencywise_details.Candidate) as 'Total Candidates',
		COUNT(Distinct constituencywise_details.Party) as 'No of parties',
		sum(constituencywise_details.EVM_Votes + constituencywise_details.Postal_Votes) as 'Total Votes',
		SUM(constituencywise_details.EVM_Votes) as 'Total EVM votes',
		SUM(constituencywise_details.Postal_Votes) as 'Total Postal Votes',
		statewise_results.State
		from constituencywise_results
		join constituencywise_details on constituencywise_results.Constituency_ID= constituencywise_details.Constituency_ID
		join statewise_results on statewise_results.Parliament_Constituency = constituencywise_results.Parliament_Constituency
		where statewise_results.State = 'Andhra Pradesh'
		group by statewise_results.State;