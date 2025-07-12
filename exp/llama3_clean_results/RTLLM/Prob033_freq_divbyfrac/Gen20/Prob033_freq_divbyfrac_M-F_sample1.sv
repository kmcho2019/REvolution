module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter DIV_CLK = 7;  // Total clock cycles for 3.5x division
parameter DIV_CLK_LONG = 4;  // Longer part of the divided clock cycle
parameter DIV_CLK_SHORT = 3;  // Shorter part of the divided clock cycle

// Internal signals
reg [1:0] state;  // State machine for long and short pulses
reg [2:0] cnt;  // Counter for divided clock cycle
reg clk_int;  // Intermediate divided clock signal
reg prev_state;  // Previous state for phase-shifting

// Sequential logic for state machine and counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;  // Initialize to long pulse state
        cnt <= 3'b000;
        clk_int <= 1'b0;
        prev_state <= 2'b00;
        clk_div <= 1'b0;
    end else begin
        // Update counter based on state
        if (state == 2'b00) begin  // Long pulse state
            if (cnt == DIV_CLK_LONG - 1) begin
                cnt <= 3'b000;
                state <= 2'b01;  // Transition to short pulse state
            end else begin
                cnt <= cnt + 1'b1;
            end
        end else begin  // Short pulse state
            if (cnt == DIV_CLK_SHORT - 1) begin
                cnt <= 3'b000;
                state <= 2'b00;  // Transition back to long pulse state
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
        
        // Generate intermediate divided clock signal
        if (state == 2'b00) begin
            clk_int <= (cnt < DIV_CLK_LONG - 1) ? 1'b1 : 1'b0;
        end else begin
            clk_int <= (cnt < DIV_CLK_SHORT - 1) ? 1'b1 : 1'b0;
        end
        
        // Update previous state for phase-shifting
        prev_state <= state;
        
        // Assign the final divided clock output
        if (state == prev_state) begin
            clk_div <= clk_int;
        end else begin
            // Phase-shifting based on state transition
            if (prev_state == 2'b00 && state == 2'b01) begin
                clk_div <= ~clk_int;  // Phase-shift on transition from long to short
            end else if (prev_state == 2'b01 && state == 2'b00) begin
                clk_div <= clk_int;  // No phase-shift on transition from short to long
            end
        end
    end
end

endmodule