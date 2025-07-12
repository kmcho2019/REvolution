module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Initialize counter to 4 (matches waveform)
initial begin
    q = 3'd4;
end

always @(posedge clk) begin
    if (!a) begin
        // Increment with wrap-around (4→5→6→0→1...)
        q <= (q == 3'd6) ? 3'd0 : q + 1;
    end
    // When a=1, q maintains its value (hold)
end

endmodule