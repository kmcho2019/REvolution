module TopModule(
    input clk,
    input ar,
    input d,
    output q
);

reg q_reg; // register to hold the state of the flip flop

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q_reg <= 1'b0; // reset the state if asynchronous reset is asserted
    end else begin
        q_reg <= d; // update the state with input d on the positive edge of clk
    end
end

assign q = q_reg; // output the current state of the flip flop

endmodule