module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;
reg [7:0] lut_value;

// Simple LUT to store pre-computed values for each frequency
always @(*) begin
    case (freq)
        8'd1: lut_value = 8'd1;
        8'd2: lut_value = 8'd2;
        8'd3: lut_value = 8'd3;
        // ... fill in the rest of the cases up to 8'd255
        8'd255: lut_value = 8'd255;
        default: lut_value = 8'd1; // Default case for invalid frequencies
    endcase
end

always @(posedge clk) begin
    if (count == lut_value - 1) begin
        wave_out <= ~wave_out;
        count <= 8'd0;
    end else begin
        count <= count + 8'd1;
    end
end

endmodule