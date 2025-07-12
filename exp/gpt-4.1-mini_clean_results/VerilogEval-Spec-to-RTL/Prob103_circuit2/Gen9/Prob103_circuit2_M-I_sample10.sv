module TopModule (
    input  wire [3:0] in,  // Combine inputs into a vector for clarity and potential optimization
    output wire       q
);

assign q = ~^in;

endmodule