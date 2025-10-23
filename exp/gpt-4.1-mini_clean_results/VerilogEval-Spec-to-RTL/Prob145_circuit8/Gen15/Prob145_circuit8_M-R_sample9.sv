module TopModule(
    input clock,
    input a,
    output p,
    output q
);
    reg p_reg, q_reg;

    // Initialize registers to unknown ('x') for simulation alignment with waveform
    initial begin
        p_reg = 1'bx;
        q_reg = 1'bx;
    end

    always @(posedge clock) begin
        p_reg <= a;
        q_reg <= p_reg;
    end

    assign p = p_reg;
    assign q = q_reg;

endmodule