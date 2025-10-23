module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    reg p_reg, q_reg;
    wire next_p;
    wire next_q;

    assign next_p = a & q_reg;
    assign next_q = p_reg;

    always @(posedge clock) begin
        p_reg <= next_p;
        q_reg <= next_q;
    end

    always @(*) begin
        p = p_reg;
        q = q_reg;
    end

endmodule