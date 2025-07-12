module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Construct inputs for the Majority Voter
wire voter_input1 = x2 & ~x3; // Condition 1: x2 is 1 and x3 is 0
wire voter_input2 = x1 & x3;  // Condition 2: x1 is 1 and x3 is 1
wire voter_input3 = ~(x2 & x3 & ~x1) & ~(~x2 & x3 & x1); // Additional condition to ensure majority

// Majority Voter implementation
assign f = (voter_input1 & voter_input2) | (voter_input1 & voter_input3) | (voter_input2 & voter_input3);

endmodule