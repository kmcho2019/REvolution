module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Initialize q to 4 on reset (not shown in waveforms but for safe design)
initial begin
    q = 3'd4;
end

always @(posedge clk) begin
    if (a) begin
        // When a is 1, force q = 4
        q <= 3'd4;
    end else begin
        // When a is 0, increment q modulo 7 within [0..6]
        // If q==6, next is 0; else q+1
        if (q == 3'd6)
            q <= 3'd0;
        else
            q <= q + 3'd1;
    end
end

endmodule