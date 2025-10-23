module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // One-hot state encoding for better power and timing
    parameter [4:0] S0 = 5'b00001;
    parameter [4:0] S1 = 5'b00010;
    parameter [4:0] S2 = 5'b00100;
    parameter [4:0] S3 = 5'b01000;
    parameter [4:0] S4 = 5'b10000;

    reg [4:0] state;
    wire clk_gated;

    // Clock gating for stable state (S0 when x=0)
    assign clk_gated = clk & ~(state == S0 & ~x);

    // Output logic using state bits directly
    assign z = state[3] | state[4];  // S3 or S4

    // State transition logic with unique case
    always_ff @(posedge clk_gated or posedge reset) begin
        if (reset) begin
            state <= S0;
        end else begin
            unique case (1'b1)  // Synthesis parallel case
                state[0]: state <= x ? S1 : S0;  // S0
                state[1]: state <= x ? S4 : S1;  // S1
                state[2]: state <= x ? S1 : S2;  // S2
                state[3]: state <= x ? S2 : S1;  // S3
                state[4]: state <= x ? S4 : S3;  // S4
                default:  state <= S0;
            endcase
        end
    end

endmodule