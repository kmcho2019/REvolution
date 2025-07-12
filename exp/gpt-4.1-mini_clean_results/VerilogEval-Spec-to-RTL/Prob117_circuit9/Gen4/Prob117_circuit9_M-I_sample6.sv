module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// No reset input given; initialize q to unknown as per waveform (x at start)
// So we keep initial state undefined.

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4; // Hold q=4 when a=1
    end else begin
        // Increment q modulo 7: (q + 1) % 7
        // q is 3-bit, max 7, so we do wrap-around manually.
        if (q == 3'd6)
            q <= 3'd0;
        else
            q <= q + 3'd1;
    end
end

endmodule