module TopModule (
    input  clk,  // clock
    input  d,    // input data
    input  r,    // reset
    output q     // output data
);

reg q_reg;  // internal register to hold the output value
assign q = q_reg;  // continuous assignment to output

always @(posedge clk) begin
    if (r) begin
        q_reg <= 1'b0;  // reset to 0 if r is high
    end else begin
        q_reg <= d;    // capture input d if r is low
    end
end

endmodule