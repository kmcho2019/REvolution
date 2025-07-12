module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// State encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

// Output logic
assign out = (state == 4'b1000); // Output is 1 only for state D

// Next state logic for each bit position
assign next_state[0] = (~in & (state == 4'b1000)) | (~in & (state == 4'b0001)) | (in & (state == 4'b0100));
assign next_state[1] = (in & (state == 4'b0001)) | (in & (state == 4'b0010)) | (~in & (state == 4'b1000)) | (in & (state == 4'b1000));
assign next_state[2] = (~in & (state == 4'b0010)) | (in & (state == 4'b0100));
assign next_state[3] = (in & (state == 4'b0100));

endmodule