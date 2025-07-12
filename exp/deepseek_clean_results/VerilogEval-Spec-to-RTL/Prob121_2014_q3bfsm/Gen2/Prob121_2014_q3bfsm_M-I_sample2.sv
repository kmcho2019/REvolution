module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot state encoding
    reg [4:0] state;  // S0-S4
    wire clk_enable = !((state[0] && !x) || (state[4] && x);  // Clock gating for stable states

    // State definitions
    parameter S0 = 5'b00001,
              S1 = 5'b00010,
              S2 = 5'b00100,
              S3 = 5'b01000,
              S4 = 5'b10000;

    // Clock gating logic
    wire gated_clk;
    assign gated_clk = clk & clk_enable;

    // Combined state transition and output logic
    always @(posedge gated_clk or posedge reset) begin
        if (reset) begin
            state <= S0;
            z <= 0;
        end
        else begin
            case (1'b1)  // Synthesis will optimize this for one-hot
                state[0]: begin  // S0
                    state <= x ? S1 : S0;
                    z <= 0;
                end
                state[1]: begin  // S1
                    state <= x ? S4 : S1;
                    z <= 0;
                end
                state[2]: begin  // S2
                    state <= x ? S1 : S2;
                    z <= 0;
                end
                state[3]: begin  // S3
                    state <= x ? S2 : S1;
                    z <= 1;
                end
                state[4]: begin  // S4
                    state <= x ? S4 : S3;
                    z <= 1;
                end
                default: begin
                    state <= S0;
                    z <= 0;
                end
            endcase
        end
    end

endmodule