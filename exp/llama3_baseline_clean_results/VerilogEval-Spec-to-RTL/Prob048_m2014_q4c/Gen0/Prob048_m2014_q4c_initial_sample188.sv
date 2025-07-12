module TopModule(
    input clk,
    input d,
    input r,
    output q
);

reg q_reg; // internal register to hold the output value
assign q = q_reg; // continuous assignment to output the value of the internal register

always @(posedge clk) // sequential block sensitive to positive clock edge
    if (r) // check for reset condition
        q_reg <= 0; // reset output to 0 if r is high
    else
        q_reg <= d; // capture input data if r is not high

endmodule