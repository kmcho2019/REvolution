module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Initialize q to 4 (from waveform initial condition)
initial q = 3'd4;

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4; // force state 4 when a is high
    end else begin
        // Increment modulo 7: if q == 6, wrap to 0, else q + 1
        if (q == 3'd6)
            q <= 3'd0;
        else
            q <= q + 3'd1;
    end
end

endmodule