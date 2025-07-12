module TopModule(
    input clk,  // clock signal
    input ar,  // asynchronous reset
    input d,   // input data
    output q   // output data
);

reg q_reg;  // register to store the output value

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q_reg <= 1'b0;  // reset output to 0 when ar is high
    end else if (posedge clk) begin
        q_reg <= d;  // update output on positive edge of clk
    end
end

assign q = q_reg;  // assign the output value

endmodule