module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // Binary state encoding
    parameter [2:0] S0 = 3'b000,
                    S1 = 3'b001,
                    S2 = 3'b010,
                    S3 = 3'b011,
                    S4 = 3'b100;

    reg [2:0] state, next_state;
    wire clk_enable;

    // Clock gating logic for power optimization
    assign clk_enable = reset || 
                       (state == S0 && x) || 
                       (state == S1 && x) || 
                       (state == S2) || 
                       (state == S3) || 
                       (state == S4 && !x);

    // Next state logic using case statement
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
            default: next_state = S0;
        endcase
    end

    // Output logic - registered for better timing
    always @(*) begin
        z = (state == S3) | (state == S4);
    end

    // State register with synchronous reset and clock gating
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end
        else if (clk_enable) begin
            state <= next_state;
        end
    end

endmodule