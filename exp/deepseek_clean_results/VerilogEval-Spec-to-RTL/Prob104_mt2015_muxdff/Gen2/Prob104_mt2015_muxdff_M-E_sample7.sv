module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire load_clk = clk & L;
    wire feedback_clk = clk & ~L;
    wire effective_clk = load_clk | feedback_clk;
    wire D = L ? r_in : q_in;

    always @(posedge effective_clk)
        Q <= D;

endmodule