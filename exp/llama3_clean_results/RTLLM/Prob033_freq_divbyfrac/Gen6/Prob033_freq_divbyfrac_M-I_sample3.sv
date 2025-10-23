module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Enum for state machine
enum logic [2:0] {IDLE, DIV_4, DIV_3, PHASE_SHIFT} state, next_state;

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg prev_clk;  // Previous clock value for edge detection
reg clk_div_int1;  // Intermediate divided clock (4 cycles)
reg clk_div_int2;  // Intermediate divided clock (3 cycles)
reg clk_div_phase_shifted;  // Phase-shifted version of divided clock

// Sequential logic for state machine and counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        cnt <= 3'b000;
        prev_clk <= 1'b0;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_phase_shifted <= 1'b0;
    end else begin
        state <= next_state;
        if (next_state == IDLE) begin
            cnt <= 3'b000;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        prev_clk <= clk;
        if (state == DIV_4) begin
            clk_div_int1 <= 1'b1;
        end else begin
            clk_div_int1 <= 1'b0;
        end
        if (state == DIV_3) begin
            clk_div_int2 <= 1'b1;
        end else begin
            clk_div_int2 <= 1'b0;
        end
        if (state == PHASE_SHIFT) begin
            clk_div_phase_shifted <=!clk_div_int1 && clk_div_int2;
        end else begin
            clk_div_phase_shifted <= 1'b0;
        end
    end
end

// Combinational logic for state transitions
always @(*) begin
    case (state)
        IDLE: begin
            if (cnt < 4) begin
                next_state = DIV_4;
            end else begin
                next_state = DIV_3;
            end
        end
        DIV_4: begin
            if (cnt >= 4) begin
                next_state = PHASE_SHIFT;
            end else begin
                next_state = DIV_4;
            end
        end
        DIV_3: begin
            if (cnt == MUL2_DIV_CLK - 1) begin
                next_state = IDLE;
            end else begin
                next_state = DIV_3;
            end
        end
        PHASE_SHIFT: begin
            next_state = IDLE;
        end
    endcase
end

// Combinational logic for final fractional divided clock output
assign clk_div = clk_div_int1 || clk_div_int2 || clk_div_phase_shifted;

endmodule