module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Directly implementing the required logic using a single assignment statement
assign out = (~in3 & (in1 == in2)) | (in3 & (in1!= in2));

// Alternatively, expressing the logic using XOR and XNOR gates explicitly for better understanding
// wire xnor_out;
// assign xnor_out = ~(in1 ^ in2);
// assign out = xnor_out ^ in3;

endmodule