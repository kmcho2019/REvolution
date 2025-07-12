module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

    reg state_reg;
    wire q_comb;

    assign q_comb = state_reg ? ~(a | b) : (a ^ b);
    assign q = q_comb;
    assign state = state_reg;

    always @(posedge clk) begin
        state_reg <= q_comb;
    end

endmodule