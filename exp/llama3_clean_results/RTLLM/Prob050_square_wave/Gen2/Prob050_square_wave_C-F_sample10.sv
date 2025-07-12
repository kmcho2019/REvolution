module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        wave_out <= ~wave_out; // Toggle wave_out using non-blocking assignment
        count <= 8'd0; // Reset count using non-blocking assignment
    end else begin
        count <= count + 8'd1; // Increment count using non-blocking assignment
    end
end

initial begin
    wave_out = 1'b0; // Initialize wave_out to a known state
end

endmodule