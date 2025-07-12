module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Use a 4-to-1 MUX to select between different combinations of inputs
wire mux_out;
wire in1_in2_same = ~(in1 ^ in2);
wire in1_in2_diff = in1 ^ in2;

assign mux_out = (in1_in2_same) ? 1'b1 : 1'b0;

// XOR the MUX output with 'in3' to produce the final output
assign out = mux_out ^ in3;

endmodule