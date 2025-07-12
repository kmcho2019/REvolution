module TopModule(
    input clk,
    input d,
    output reg q
);
    reg internal_q; // Internal signal between the two latches

    // First transparent latch, enabled during the low phase of the clock
    always @(*) begin
        if (~clk) begin
            internal_q <= d;
        end
    end

    // Second transparent latch, enabled during the high phase of the clock
    always @(*) begin
        if (clk) begin
            q <= internal_q;
        end
    end
endmodule