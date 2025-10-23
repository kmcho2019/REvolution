module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        wave_out <= ~wave_out; // toggle the wave_out signal
        count <= 8'd0; // reset the count register
    end else begin
        count <= count + 1; // increment the count register
    end
end

endmodule