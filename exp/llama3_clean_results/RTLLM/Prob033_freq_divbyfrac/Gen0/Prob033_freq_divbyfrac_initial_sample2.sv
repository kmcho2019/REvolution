module freq_divbyfrac (
    input  wire        clk,       // Input clock signal
    input  wire        rst_n,     // Active low reset signal
    output reg         clk_div    // Fractionally divided clock output
);

// Define constants for division
localparam MUL2_DIV_CLK = 7;  // Count of clock cycles for 3.5x division

// Counter to cycle through clock periods
reg [2:0] counter;
reg [2:0] next_counter;

// Signals for intermediate divided clocks
reg clk_div_int_4;
reg clk_div_int_3;
reg clk_div_int_4_phase_shifted;
reg clk_div_int_3_phase_shifted;

// Combine phase-shifted clocks to produce final output
assign clk_div = clk_div_int_4_phase_shifted | clk_div_int_3_phase_shifted;

// Sequential logic
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize on reset
        counter <= 3'b000;
        clk_div_int_4 <= 1'b0;
        clk_div_int_3 <= 1'b0;
        clk_div_int_4_phase_shifted <= 1'b0;
        clk_div_int_3_phase_shifted <= 1'b0;
    end else begin
        // Increment counter
        counter <= next_counter;

        // Set intermediate clocks based on counter value
        if (counter == 3'b100) begin
            // Start of 4-cycle clock period
            clk_div_int_4 <= 1'b1;
            clk_div_int_3 <= 1'b0;
        end else if (counter == 3'b011) begin
            // Start of 3-cycle clock period
            clk_div_int_4 <= 1'b0;
            clk_div_int_3 <= 1'b1;
        end else if (counter == 3'b001) begin
            // End of clock period
            clk_div_int_4 <= 1'b0;
            clk_div_int_3 <= 1'b0;
        end

        // Phase-shift intermediate clocks
        if (counter == 3'b101) begin
            // Delay 4-cycle clock by half a cycle
            clk_div_int_4_phase_shifted <= 1'b1;
        end else if (counter == 3'b110) begin
            // Advance 3-cycle clock by half a cycle
            clk_div_int_3_phase_shifted <= 1'b1;
        end else if (counter == 3'b000) begin
            // Reset phase-shifted clocks
            clk_div_int_4_phase_shifted <= 1'b0;
            clk_div_int_3_phase_shifted <= 1'b0;
        end
    end
end

// Combinational logic for counter increment
always @ (*) begin
    if (counter == MUL2_DIV_CLK - 1) begin
        next_counter = 3'b000;
    end else begin
        next_counter = counter + 1'b1;
    end
end

endmodule