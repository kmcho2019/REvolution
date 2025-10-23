module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state;  // 0: copy state, 1: invert state

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
            z <= 0;
        end else case (state)
            0: begin
                z <= x;
                state <= x;  // Transition to invert state when first '1' seen
            end
            1: z <= ~x;      // Stay in invert state and complement bits
        endcase
    end

endmodule