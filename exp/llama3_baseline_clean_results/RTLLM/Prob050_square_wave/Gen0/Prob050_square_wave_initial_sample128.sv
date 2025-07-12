module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;

always @ (posedge clk) begin
    if (count == (freq - 1)) begin
        wave_out = ~wave_out; // toggle wave_out
        count = 0; // reset count
    end else begin
        count = count + 1; // increment count
    end
end

endmodule