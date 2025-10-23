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

    // Clock gating for power optimization
    assign clk_enable = reset || 
                       (state != next_state) || 
                       ((state == S0) && x) || 
                       ((state == S1) && x) || 
                       ((state == S2) && x) || 
                       ((state == S3) && (x || !x)) || 
                       ((state == S4) && !x);

    // Combined next state and output logic
    always @(*) begin
        case (state)
            S0: begin
                next_state = x ? S1 : S0;
                z = 1'b0;
            end
            S1: begin
                next_state = x ? S4 : S1;
                z = 1'b0;
            end
            S2: begin
                next_state = x ? S1 : S2;
                z = 1'b0;
            end
            S3: begin
                next_state = x ? S2 : S1;
                z = 1'b1;
            end
            S4: begin
                next_state = x ? S4 : S3;
                z = 1'b1;
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

    // State register with synchronous reset and clock gating
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end
        else if (clk_enable) begin
            state <= next_state;
            // z is already set in combinational logic
        end
    end

endmodule