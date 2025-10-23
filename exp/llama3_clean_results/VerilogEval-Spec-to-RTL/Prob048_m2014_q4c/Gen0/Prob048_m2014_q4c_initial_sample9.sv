module TopModule(
    input  clk,  // clock signal
    input  d,    // data input
    input  r,    // active high reset
    output q     // data output
);

reg q_reg;  // internal register to store the output value

always @(posedge clk) begin
    if (r) begin  // if reset is high
        q_reg <= 1'b0;  // reset output to 0
    end else begin
        q_reg <= d;  // capture input data
    end
end

assign q = q_reg;  // assign internal register value to output

endmodule