module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

  // Define the states S0 through S9 using parameters
  parameter S0 = 10'b0000000001;
  parameter S1 = 10'b0000000010;
  parameter S2 = 10'b0000000100;
  parameter S3 = 10'b0000001000;
  parameter S4 = 10'b0000010000;
  parameter S5 = 10'b0000100000;
  parameter S6 = 10'b0001000000;
  parameter S7 = 10'b0010000000;
  parameter S8 = 10'b0100000000;
  parameter S9 = 10'b1000000000;

  // Define the state transition and output lookup table based on the given state machine transitions
  reg [9:0] next_state_table[9:0];  // Lookup table for next state values
  reg out1_table[9:0];               // Lookup table for out1 values
  reg out2_table[9:0];               // Lookup table for out2 values
  
  // Populate the lookup tables
  initial begin
    // Initialize next state values in the lookup table
    next_state_table[S0] = in ? S1 : S0;
    next_state_table[S1] = in ? S2 : S0;
    next_state_table[S2] = in ? S3 : S0;
    next_state_table[S3] = in ? S4 : S0;
    next_state_table[S4] = in ? S5 : S0;
    next_state_table[S5] = in ? S6 : S8;
    next_state_table[S6] = in ? S7 : S9;
    next_state_table[S7] = in ? S7 : S0;
    next_state_table[S8] = in ? S1 : S0;
    next_state_table[S9] = in ? S1 : S0;
    
    // Initialize output values in the lookup table
    out1_table[S0] = 1'b0; out2_table[S0] = 1'b0;
    out1_table[S1] = 1'b0; out2_table[S1] = 1'b0;
    out1_table[S2] = 1'b0; out2_table[S2] = 1'b0;
    out1_table[S3] = 1'b0; out2_table[S3] = 1'b0;
    out1_table[S4] = 1'b0; out2_table[S4] = 1'b0;
    out1_table[S5] = 1'b0; out2_table[S5] = 1'b0;
    out1_table[S6] = 1'b0; out2_table[S6] = 1'b0;
    out1_table[S7] = 1'b0; out2_table[S7] = 1'b1;
    out1_table[S8] = 1'b1; out2_table[S8] = 1'b0;
    out1_table[S9] = 1'b1; out2_table[S9] = 1'b1;
  end

  // Assign next state and outputs based on the lookup tables
  assign next_state = next_state_table[state];
  assign out1 = out1_table[state];
  assign out2 = out2_table[state];

endmodule