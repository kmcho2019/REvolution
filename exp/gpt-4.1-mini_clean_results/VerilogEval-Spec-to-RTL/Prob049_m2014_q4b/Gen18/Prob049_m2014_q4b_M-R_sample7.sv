module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output q
);

reg q_reg;

// Asynchronous reset process
always @(posedge clk or posedge ar) begin
    if (ar)
        q_reg <= 1'b0;
    else
        q_reg <= d;
end

assign q = q_reg;

endmodule