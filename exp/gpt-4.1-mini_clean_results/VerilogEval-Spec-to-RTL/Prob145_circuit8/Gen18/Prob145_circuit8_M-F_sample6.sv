module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    reg p_reg, q_reg;
    wire p_next, q_next;

    assign p_next = a | q_reg;
    assign q_next = p_reg;

    always @(posedge clock) begin
        p_reg <= p_next;
        q_reg <= q_next;
    end

    always @(*) begin
        p = p_reg;
        q = q_reg;
    end

endmodule