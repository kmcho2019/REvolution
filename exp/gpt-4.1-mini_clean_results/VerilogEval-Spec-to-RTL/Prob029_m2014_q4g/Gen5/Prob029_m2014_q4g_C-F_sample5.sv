module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

wire xnor_out;

// Use the built-in xnor primitive for clarity and structural design
xnor u_xnor (xnor_out, in1, in2);

// Use the built-in xor primitive as the final stage
xor u_xor (out, xnor_out, in3);

endmodule