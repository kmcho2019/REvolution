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
    if (a) begin
        // When a=1, force q to 4
        q <= 3'd4;
    end
    else begin
        // When a=0, increment with wrap-around (4→5→6→0→1...)
        q <= (q == 3'd6) ? 3'd0 : q + 1;
    end
end

endmodule