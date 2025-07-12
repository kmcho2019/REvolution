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
    STATE_SHORT_PULSE,
    STATE_PHASE_SHIFT
} state;

// Internal signals
reg [2:0] cnt_long;  // Counter for longer clock period
reg [2:0] cnt_short;  // Counter for shorter clock period
reg clk_int1;  // Intermediate divided clock signal 1 (longer part)
reg clk_int2;  // Intermediate divided clock signal 2 (shorter part)
reg clk_int1_delayed;  // Delayed version of clk_int1
reg clk_int2_advanced;  // Advanced version of clk_int2

// Sequential logic for counter and state machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_long <= 3'b000;
        cnt_short <= 3'b000;
        state <= STATE_IDLE;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        clk_int1_delayed <= 1'b0;
        clk_int2_advanced <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        case (state)
            STATE_IDLE: begin
                if (cnt_long == DIV_CLK_LONG - 1 && cnt_short == DIV_CLK_SHORT - 1) begin
                    cnt_long <= 3'b000;
                    cnt_short <= 3'b000;
                    state <= STATE_LONG_PULSE;
                end else begin
                    cnt_long <= cnt_long + 1'b1;
                    cnt_short <= cnt_short + 1'b1;
                end
            end
            STATE_LONG_PULSE: begin
                if (cnt_long < DIV_CLK_LONG) begin
                    clk_int1 <= 1'b1;
                    cnt_long <= cnt_long + 1'b1;
                end else begin
                    clk_int1 <= 1'b0;
                    state <= STATE_SHORT_PULSE;
                end
            end
            STATE_SHORT_PULSE: begin
                if (cnt_short < DIV_CLK_SHORT) begin
                    clk_int2 <= 1'b1;
                    cnt_short <= cnt_short + 1'b1;
                end else begin
                    clk_int2 <= 1'b0;
                    state <= STATE_PHASE_SHIFT;
                end
            end
            STATE_PHASE_SHIFT: begin
                clk_int1_delayed <= clk_int1;
                clk_int2_advanced <= clk_int2;
                state <= STATE_IDLE;
            end
            default: begin
                state <= STATE_IDLE;
            end
        endcase
        // Assign the final divided clock output
        clk_div <= (clk_int1 || clk_int2 || clk_int1_delayed || clk_int2_advanced);
    end
end

endmodule