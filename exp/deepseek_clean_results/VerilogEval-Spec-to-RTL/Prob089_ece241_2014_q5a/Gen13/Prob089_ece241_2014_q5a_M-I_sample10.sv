module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state;  // 0: copy state, 1: invert state
    reg next_state;

    // Clock gating during reset
    wire gated_clk = areset ? 1'b0 : clk;

    // State transition logic
    always @(posedge gated_clk or posedge areset) begin
        if (areset) begin
            state <= 0;
            next_state <= 0;
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for next state and output
    always @(*) begin
        if (areset) begin
            z = 1'b0;
            next_state = 1'b0;
        end else begin
            case (state)
                0: begin
                    z = x;
                    next_state = x;  // Transition on first '1'
                end
                1: begin
                    z = ~x;         // Invert all subsequent bits
                    next_state = 1'b1;
                end
            endcase
        end
    end

endmodule