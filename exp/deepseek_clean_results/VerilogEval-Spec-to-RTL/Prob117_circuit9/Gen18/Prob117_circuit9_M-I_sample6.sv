module TopModule (
    input clk,
    input a,
    output reg [2:0] q = 3'b100  // Initialize to 4 (matches waveform)
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'b100;  // Force to 4 when a is high
    end else begin
        q <= (q == 3'b110) ? 3'b000 : (q + 1);  // Increment with wrap-around
    end
end

endmodule