module freq_divbyfrac (
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for frequency division ratio
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter DIV_CLK_HIGH = 4; // Clock cycles for high period
parameter DIV_CLK_LOW = 3; // Clock cycles for low period

// Internal signals
reg [2:0] cnt; // Counter for clock cycles
reg clk_div_int; // Intermediate divided clock signal
reg clk_div_int_delayed; // Delayed intermediate divided clock signal
reg clk_div_int_advanced; // Advanced intermediate divided clock signal

// FSM states
enum logic [1:0] {
    STATE_IDLE,
    STATE_DIV_HIGH,
    STATE_DIV_LOW
} state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= STATE_IDLE;
        cnt <= 3'b000;
        clk_div_int <= 1'b0;
        clk_div_int_delayed <= 1'b0;
        clk_div_int_advanced <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            STATE_IDLE: begin
                if (cnt == MUL2_DIV_CLK - 1) begin
                    cnt <= 3'b000;
                    next_state <= STATE_DIV_HIGH;
                end else begin
                    cnt <= cnt + 1;
                    next_state <= STATE_IDLE;
                end
            end
            STATE_DIV_HIGH: begin
                if (cnt == DIV_CLK_HIGH - 1) begin
                    next_state <= STATE_DIV_LOW;
                end else begin
                    cnt <= cnt + 1;
                    next_state <= STATE_DIV_HIGH;
                end
                clk_div_int <= 1'b1;
            end
            STATE_DIV_LOW: begin
                if (cnt == MUL2_DIV_CLK - 1) begin
                    next_state <= STATE_IDLE;
                end else begin
                    cnt <= cnt + 1;
                    next_state <= STATE_DIV_LOW;
                end
                clk_div_int <= 1'b0;
            end
        endcase
    end
end

// Delay and advance the intermediate divided clock signal
always @(posedge clk) begin
    clk_div_int_delayed <= clk_div_int;
    clk_div_int_advanced <= clk_div_int;
end

// Phase-shift the divided clock signals
assign clk_div = clk_div_int | clk_div_int_delayed | clk_div_int_advanced;

endmodule