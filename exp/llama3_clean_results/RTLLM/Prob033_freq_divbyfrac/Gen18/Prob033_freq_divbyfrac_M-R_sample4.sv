module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for FSM controller
reg [2:0] state;  // Current state of the FSM
reg [2:0] next_state;  // Next state of the FSM

// Signals for PWM signal generation
reg pwm_signal;        // PWM signal

// Signals for clock signal generation
reg clk_enable;        // Enable signal for clock signal generation

// FSM controller
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 3'd0;  // Initialize state to 0
    end else begin
        // Update state based on current state and input signals
        case (state)
            3'd0: state <= 3'd1;
            3'd1: state <= 3'd2;
            3'd2: state <= 3'd3;
            3'd3: state <= 3'd4;
            3'd4: state <= 3'd5;
            3'd5: state <= 3'd6;
            3'd6: state <= 3'd0;
            default: state <= 3'd0;
        endcase
    end
end

// PWM signal generation
assign pwm_signal = (state < 3'd4) ? 1'b1 : 1'b0;

// Clock signal generation
assign clk_enable = pwm_signal;
assign clk_div = clk_enable ? clk : 1'b0;

endmodule