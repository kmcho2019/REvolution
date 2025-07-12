module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

parameter START = 4'b0001;  // Starting value (1)
parameter END   = 4'b1010;  // Ending value (10)

reg [3:0] q_reg;

always @(posedge clk) begin
    if (reset)
        q_reg <= START;
    else if (q_reg == END)
        q_reg <= START;
    else
        q_reg <= q_reg + 1;
end

assign q = q_reg;

endmodule