module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] lfsr = 8'd1; // Initial value for LFSR
reg [7:0] freq_div = 8'd0; // Frequency divider output
reg toggle_signal = 1'b0; // Signal to toggle wave_out

// LFSR logic (example with a simple polynomial)
always @(posedge clk) begin
    lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[4] ^ lfsr[3] ^ lfsr[2]};
end

// Frequency divider logic
always @(posedge clk) begin
    if (freq_div == freq) begin
        freq_div <= 8'd0;
        toggle_signal <= ~toggle_signal;
    end else begin
        freq_div <= freq_div + 8'd1;
    end
end

// Toggle control logic
always @(posedge clk) begin
    if (toggle_signal) begin
        wave_out <= ~wave_out;
        toggle_signal <= 1'b0;
    end
end

endmodule