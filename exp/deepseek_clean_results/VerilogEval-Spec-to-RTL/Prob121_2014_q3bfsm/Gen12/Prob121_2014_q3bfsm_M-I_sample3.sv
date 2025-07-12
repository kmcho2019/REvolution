module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot state encoding
    parameter S0 = 5'b00001;
    parameter S1 = 5'b00010;
    parameter S2 = 5'b00100;
    parameter S3 = 5'b01000;
    parameter S4 = 5'b10000;

    reg [4:0] state;
    reg x_prev;
    wire x_changed = (x != x_prev);
    wire clk_enable = x_changed | reset;

    // Input change detection for clock gating
    always @(posedge clk) begin
        x_prev <= x;
    end

    // State transition logic with clock gating
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end
        else if (clk_enable) begin
            case (1'b1)  // Synthesis-special case for one-hot
                state[0]: state <= x ? S1 : S0;    // S0
                state[1]: state <= x ? S4 : S1;    // S1
                state[2]: state <= x ? S1 : S2;    // S2
                state[3]: state <= x ? S2 : S1;    // S3
                state[4]: state <= x ? S4 : S3;    // S4
            endcase
        end
    end

    // Registered output for better timing
    always @(posedge clk) begin
        if (reset) begin
            z <= 1'b0;
        end else begin
            z <= (state[3] | state[4]);  // S3 or S4
        end
    end

endmodule