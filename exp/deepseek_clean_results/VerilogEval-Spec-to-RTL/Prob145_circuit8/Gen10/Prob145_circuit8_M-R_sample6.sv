module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg p_reg, q_reg;

// p behavior - samples 'a' only during clock high
assign p = clock ? a : p_reg;

// q behavior - holds previous p during clock low
assign q = clock ? q_reg : p_reg;

always @(posedge clock or negedge clock) begin
    if (clock) begin
        // Clock high phase
        p_reg <= a;
    end
    else begin
        // Clock low phase
        q_reg <= p_reg;
        if (~a) begin
            p_reg <= 1'b0;
            q_reg <= 1'b0;
        end
    end
end

endmodule