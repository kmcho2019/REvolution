module TopModule(
    input  clk, // clock
    input  d,  // data input
    input  r,  // reset input (active high)
    output q   // output
);

reg q_reg; // register to hold the output value
assign q = q_reg; // assign the reg value to the output

always @(posedge clk) begin
    if (r) begin
        q_reg <= 1'b0; // reset output to 0 when r is high
    end else begin
        q_reg <= d; // capture input d when r is low
    end
end

endmodule