module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

// Define the conditions for each state
wire is_S0 = (state == 10'b0000000001);
wire is_S1 = (state == 10'b0000000010);
wire is_S2 = (state == 10'b0000000100);
wire is_S3 = (state == 10'b0000001000);
wire is_S4 = (state == 10'b0000010000);
wire is_S5 = (state == 10'b0000100000);
wire is_S6 = (state == 10'b0001000000);
wire is_S7 = (state == 10'b0010000000);
wire is_S8 = (state == 10'b0100000000);
wire is_S9 = (state == 10'b1000000000);

// Determine the next state based on the current state and input
always @* begin
    case(state)
        10'b0000000001: next_state = in ? 10'b0000000010 : 10'b0000000001; // S0
        10'b0000000010: next_state = in ? 10'b0000000100 : 10'b0000000001; // S1
        10'b0000000100: next_state = in ? 10'b0000001000 : 10'b0000000001; // S2
        10'b0000001000: next_state = in ? 10'b0000010000 : 10'b0000000001; // S3
        10'b0000010000: next_state = in ? 10'b0000100000 : 10'b0000000001; // S4
        10'b0000100000: next_state = in ? is_S8 ? 10'b0100000000 : 10'b0001000000 : 10'b0000000001; // S5
        10'b0001000000: next_state = in ? is_S9 ? 10'b1000000000 : 10'b0100000000 : 10'b0000000001; // S6
        10'b0010000000: next_state = in ? 10'b0010000000 : 10'b0000000001; // S7
        10'b0100000000: next_state = in ? 10'b0000000010 : 10'b0000000001; // S8
        10'b1000000000: next_state = in ? 10'b0000000010 : 10'b0000000001; // S9
        default: next_state = 10'b0000000000; // Default case
    endcase
end

// Determine the output values based on the current state
assign out1 = (is_S7 || is_S8 || is_S9);
assign out2 = (is_S0 || is_S1);

endmodule