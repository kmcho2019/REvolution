module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Implement the XNOR operation using AND and OR gates
wire xnor_out;
assign xnor_out = (in1 && in2) || (!in1 && !in2);

// Implement the XOR operation with 'in3' using a conditional statement
assign out = (xnor_out == 1'b1) ^ in3;

// Alternatively, we could use a lookup table or a case statement to implement the truth table
// However, for simplicity and efficiency, the above assign statements are preferred

endmodule