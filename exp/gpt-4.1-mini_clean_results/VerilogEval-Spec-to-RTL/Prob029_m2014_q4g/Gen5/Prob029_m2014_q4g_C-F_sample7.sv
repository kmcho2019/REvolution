module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

wire xnor_out;

// Implement XNOR using equality operator for clarity and efficient synthesis
assign xnor_out = (in1 == in2);

// Combine XNOR output and in3 with XOR operator directly
assign out = xnor_out ^ in3;

endmodule