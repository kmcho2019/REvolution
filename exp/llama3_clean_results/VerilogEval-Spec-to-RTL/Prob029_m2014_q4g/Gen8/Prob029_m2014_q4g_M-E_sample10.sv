module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Intermediate signal to hold the XNOR result
wire xnor_out;

// XNOR operation using XOR and inversion
assign xnor_out = ~(in1 ^ in2);

// Final XOR operation
assign out = xnor_out ^ in3;

endmodule