module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    reg [7:0] freq_minus_1;
    reg enable;

    // Pre-compute freq-1 and enable signal
    always @(posedge clk) begin
        if (freq == 0) begin
            enable <= 1'b0;
            freq_minus_1 <= 8'b0;
        end else begin
            enable <= 1'b1;
            freq_minus_1 <= freq - 1;
        end
    end

    // Counter and wave generation with clock gating
    always @(posedge clk) begin
        if (!enable) begin
            // Frequency is 0 - hold state
            wave_out <= wave_out;
            count <= 0;
        end else if (count == freq_minus_1) begin
            // Toggle output and reset counter
            wave_out <= ~wave_out;
            count <= 0;
        end else begin
            // Increment counter
            count <= count + 1;
        end
    end

    initial begin
        wave_out = 0;
        count = 0;
        freq_minus_1 = 0;
        enable = 0;
    end

endmodule