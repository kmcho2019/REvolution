module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] main_counter;
    reg [8:0] phase_counter;  // Extra bit for phase resolution
    wire [7:0] half_period = freq >> 1;  // Automatic 50% duty cycle

    always @(posedge clk) begin
        // Main period counter
        if (main_counter == freq) begin
            main_counter <= 0;
        end else begin
            main_counter <= main_counter + 1;
        end

        // Phase counter (runs at 2x speed)
        phase_counter <= phase_counter + 1;

        // Wave generation logic
        if (phase_counter[8:1] == half_period) begin
            wave_out <= 1;
        end else if (phase_counter[8:1] == freq) begin
            wave_out <= 0;
            phase_counter <= 0;  // Reset phase counter at full period
        end
    end

endmodule