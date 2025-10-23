module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter for 3.5x division
reg [4:0] phase_acc;  // Phase accumulator for phase-shifting
reg clk_div_int;  // Intermediate divided clock signal
reg clk_div_phase_shifted;  // Phase-shifted version of divided clock signal

// Sequential logic for counter and phase accumulator
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        phase_acc <= 5'b00000;
        clk_div_int <= 1'b0;
        clk_div_phase_shifted <= 1'b0;
    end else begin
        // Counter for 3.5x division
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        
        // Phase accumulator for phase-shifting
        phase_acc <= phase_acc + 5'b00001;
        
        // Generate intermediate divided clock signal
        if (cnt < 4) begin
            clk_div_int <= 1'b1;
        end else begin
            clk_div_int <= 1'b0;
        end
        
        // Generate phase-shifted version of divided clock signal
        if (phase_acc < 5'b10000) begin
            clk_div_phase_shifted <= 1'b1;
        end else begin
            clk_div_phase_shifted <= 1'b0;
        end
    end
end

// Combinational logic for final divided clock output
assign clk_div = clk_div_int || clk_div_phase_shifted;

endmodule