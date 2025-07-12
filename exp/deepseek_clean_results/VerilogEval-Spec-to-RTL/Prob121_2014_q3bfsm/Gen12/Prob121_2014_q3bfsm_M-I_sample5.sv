module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // State encoding with parameters
    parameter [2:0] S0 = 3'b000,
                    S1 = 3'b001,
                    S2 = 3'b010,
                    S3 = 3'b011,
                    S4 = 3'b100;

    reg [2:0] state, next_state;

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

    // Clock gating logic for power optimization
    wire clk_en = ~((state == S0 & ~x) | (state == S1 & ~x) | (state == S4 & x));

    // State register with synchronous reset and clock gating
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end
        else if (clk_en) begin
            state <= next_state;
            // Output logic - z=1 when next state is S3 or S4
            z <= (next_state == S3) | (next_state == S4);
        end
    end

endmodule