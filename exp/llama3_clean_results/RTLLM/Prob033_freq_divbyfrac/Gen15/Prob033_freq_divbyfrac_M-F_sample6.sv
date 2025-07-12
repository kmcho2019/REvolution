module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter DIV_CLK = 7;  // Total clock cycles for 3.5x division
parameter DIV_CLK_LONG = 4;  // Longer part of the divided clock cycle
parameter DIV_CLK_SHORT = 3;  // Shorter part of the divided clock cycle

// Enum type for state machine states
enum logic [1:0] {
    STATE_IDLE,
    STATE_LONG_PULSE,
    STATE_SHORT_PULSE
} state;

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg clk_int1;  // Intermediate divided clock signal 1 (longer part)
reg clk_int2;  // Intermediate divided clock signal 2 (shorter part)

// Sequential logic for counter and state machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        state <= STATE_IDLE;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        case (state)
            STATE_IDLE: begin
                if (cnt == DIV_CLK - 1) begin
                    cnt <= 3'b000;
                    state <= STATE_LONG_PULSE;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
            STATE_LONG_PULSE: begin
                if (cnt < DIV_CLK_LONG) begin
                    clk_int1 <= 1'b1;
                end else begin
                    clk_int1 <= 1'b0;
                    state <= STATE_SHORT_PULSE;
                end
            end
            STATE_SHORT_PULSE: begin
                if (cnt < DIV_CLK_SHORT) begin
                    clk_int2 <= 1'b1;
                end else begin
                    clk_int2 <= 1'b0;
                    state <= STATE_IDLE;
                end
            end
            default: begin
                state <= STATE_IDLE;
            end
        endcase
        // Assign the final divided clock output
        clk_div <= (clk_int1 || clk_int2);
    end
end

endmodule