module TopModule (
    input  clk,  // clock input
    input  d,    // data input
    input  r,    // reset input
    output q     // output
);

reg q_reg;  // register to hold the output value
assign q = q_reg;  // continuous assignment to output port

always @(posedge clk) begin
    if (r) begin
        // if reset is high, reset the output to 0
        q_reg <= 1'b0;
    end else begin
        // if reset is not high, store the input 'd'
        q_reg <= d;
    end
end

endmodule