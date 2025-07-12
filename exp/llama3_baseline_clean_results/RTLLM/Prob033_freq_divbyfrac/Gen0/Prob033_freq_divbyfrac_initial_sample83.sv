module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x frequency division (7 clock cycles total)
parameter MUL2_DIV_CLK = 7;

// States for the FSM
enum logic [1:0] {
    STATE_4CYCLES,
    STATE_3CYCLES
} state, next_state;

// Counter to track clock cycles
reg [2:0] cnt;

// Intermediate clock signals
reg clk_div_int;
reg clk_div_int_shifted;

// Output buffer
reg clk_div_buf;

always @(*) begin
    // Default values
    next_state = state;
    clk_div_int = 1'b0;
    clk_div_int_shifted = 1'b0;
    clk_div_buf = 1'b0;

    case (state)
        STATE_4CYCLES: begin
            // Generate divided clock for 4-clock cycle period
            if (cnt == 3) begin
                clk_div_int = 1'b1;
            end
            // Transition to 3-clock cycle period after 4 cycles
            if (cnt == 3) begin
                next_state = STATE_3CYCLES;
            end
        end
        STATE_3CYCLES: begin
            // Generate phase-shifted divided clock for 3-clock cycle period
            if (cnt == 2) begin
                clk_div_int_shifted = 1'b1;
            end
            // Transition back to 4-clock cycle period after 3 cycles
            if (cnt == 2) begin
                next_state = STATE_4CYCLES;
            end
        end
    endcase

    // Logically OR the two intermediate clocks
    clk_div_buf = clk_div_int | clk_div_int_shifted;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the FSM and counter
        state <= STATE_4CYCLES;
        cnt <= 3'b000;
        clk_div <= 1'b0;
    end else begin
        // Update the FSM and counter
        state <= next_state;
        if (state == STATE_4CYCLES) begin
            if (cnt == 3) begin
                cnt <= 3'b000;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end else if (state == STATE_3CYCLES) begin
            if (cnt == 2) begin
                cnt <= 3'b000;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end

        // Update the output buffer
        clk_div <= clk_div_buf;
    end
end

endmodule