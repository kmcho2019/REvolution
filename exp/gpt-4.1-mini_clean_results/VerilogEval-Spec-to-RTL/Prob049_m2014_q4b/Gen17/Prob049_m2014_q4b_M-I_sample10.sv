module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output q
);

reg q_reg;

always @(posedge clk or posedge ar) begin
    if (ar)
        q_reg <= 1'b0;     // asynchronous reset: immediate zero
    else
        q_reg <= d;        // synchronous data update
end

assign q = q_reg;

endmodule