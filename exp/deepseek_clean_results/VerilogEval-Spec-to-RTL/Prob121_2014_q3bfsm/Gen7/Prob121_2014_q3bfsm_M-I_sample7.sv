module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // Binary state encoding
    parameter [2:0] S0 = 3'b000,
                    S1 = 3'b001,
                    S2 = 3'b010,
                    S3 = 3'b011,
                    S4 = 3'b100;

    reg [2:0] state, next_state;
    wire clk_enable;

    // Simplified clock gating - only enable when state changes
    assign clk_enable = reset || (state != next_state);

    // Optimized next state logic
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
        endcase
    end

    // Output logic
    assign z = (state == S3) | (state == S4);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end
        else if (clk_enable) begin
            state <= next_state;
        end
    end

endmodule