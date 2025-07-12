module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division
parameter DIV_CLK_PULSE_WIDTH = 4;  // Pulse width for divided clock signal

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg [1:0] phase_cnt;  // Counter to track phase shifts
reg prev_clk;   // Previous clock value for edge detection
reg divided_clk;  // Intermediate divided clock signal
reg phase_shifted_clk;  // Phase-shifted divided clock signal

// Sequential logic for counter and phase counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        phase_cnt <= 2'b00;
        prev_clk <= 1'b0;
        divided_clk <= 1'b0;
        phase_shifted_clk <= 1'b0;
    end else begin
        prev_clk <= clk;
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
            phase_cnt <= phase_cnt + 1'b1;
        end else begin
            cnt <= cnt + 1'b1;
        end
        
        // Update divided clock signal based on counter value
        divided_clk <= (cnt < DIV_CLK_PULSE_WIDTH)? 1'b1 : 1'b0;
        
        // Update phase-shifted clock signal based on phase counter and divided clock
        case (phase_cnt)
            2'b00, 2'b10: phase_shifted_clk <= divided_clk;
            2'b01, 2'b11: phase_shifted_clk <= (cnt[0] == 1'b1)? divided_clk : 1'b0;
            default: phase_shifted_clk <= 1'b0;
        endcase
    end
end

// Combinational logic for final output
assign clk_div = divided_clk | phase_shifted_clk;

endmodule