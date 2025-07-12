module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,    // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division
parameter DIV_CLK_HIGH = 4;  // Clock cycles for high phase
parameter DIV_CLK_LOW = 3;  // Clock cycles for low phase

reg [2:0] cnt;  // Counter for clock cycles
reg clk_div_int1;  // Intermediate divided clock signal 1
reg clk_div_int2;  // Intermediate divided clock signal 2
reg clk_div_int1_dly;  // Delayed intermediate divided clock signal 1
reg clk_div_int2_adv;  // Advanced intermediate divided clock signal 2

// FSM states
enum logic [1:0] {
    IDLE,
    HIGH_PHASE,
    LOW_PHASE
} state, next_state;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        cnt <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_int1_dly <= 1'b0;
        clk_div_int2_adv <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                cnt <= 3'b000;
                if (cnt == 3'b000) begin
                    next_state <= HIGH_PHASE;
                end else begin
                    next_state <= IDLE;
                end
            end
            HIGH_PHASE: begin
                if (cnt < DIV_CLK_HIGH) begin
                    cnt <= cnt + 1'b1;
                    next_state <= HIGH_PHASE;
                end else begin
                    next_state <= LOW_PHASE;
                    cnt <= 3'b000;
                end
            end
            LOW_PHASE: begin
                if (cnt < DIV_CLK_LOW) begin
                    cnt <= cnt + 1'b1;
                    next_state <= LOW_PHASE;
                end else begin
                    next_state <= HIGH_PHASE;
                    cnt <= 3'b000;
                end
            end
        endcase

        // Generate intermediate divided clock signals
        if (state == HIGH_PHASE) begin
            clk_div_int1 <= 1'b1;
        end else if (state == LOW_PHASE) begin
            clk_div_int1 <= 1'b0;
        end

        // Phase-shift intermediate divided clock signals
        if (state == HIGH_PHASE) begin
            clk_div_int2 <= 1'b0;
            clk_div_int1_dly <= 1'b0;
            clk_div_int2_adv <= 1'b1;
        end else if (state == LOW_PHASE) begin
            clk_div_int2 <= 1'b1;
            clk_div_int1_dly <= 1'b1;
            clk_div_int2_adv <= 1'b0;
        end

        // Generate final fractional divided clock output
        clk_div <= clk_div_int1 | clk_div_int2 | clk_div_int1_dly | clk_div_int2_adv;
    end
end

endmodule