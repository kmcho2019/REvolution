module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;
reg [7:0] lut_value;

// Simplified LUT to store pre-computed values for common frequencies
always @(*) begin
    case (freq)
        8'd1: lut_value = 8'd1;
        8'd2: lut_value = 8'd2;
        8'd4: lut_value = 8'd4;
        8'd8: lut_value = 8'd8;
        8'd16: lut_value = 8'd16;
        8'd32: lut_value = 8'd32;
        8'd64: lut_value = 8'd64;
        8'd128: lut_value = 8'd128;
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