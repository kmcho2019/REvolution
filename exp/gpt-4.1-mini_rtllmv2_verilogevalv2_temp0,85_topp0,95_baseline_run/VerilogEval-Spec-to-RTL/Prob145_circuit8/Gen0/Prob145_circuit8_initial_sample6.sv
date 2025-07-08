module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    reg p_reg;

    // On rising edge, update p based on input a
    always @(posedge clock) begin
        p_reg <= a;
        p <= a;
    end

    // On falling edge, update q based on previous p_reg
    always @(negedge clock) begin
        q <= p_reg;
    end

endmodule