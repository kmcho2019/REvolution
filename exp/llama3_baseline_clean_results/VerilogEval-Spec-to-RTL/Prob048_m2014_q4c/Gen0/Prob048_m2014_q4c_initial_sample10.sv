module TopModule(
    input  clk,  // clock signal
    input  d,    // data input
    input  r,    // reset input
    output q     // output
);

reg q_reg;  // internal register to hold the state of q
assign q = q_reg;  // assign the internal register to the output

always @(posedge clk) begin
    if (r) begin
        // if reset is high, reset the output to 0
        q_reg <= 1'b0;
    end else begin
        // if reset is not high, store the value of 'd' in the internal register
        q_reg <= d;
    end
end

endmodule