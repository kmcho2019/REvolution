module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg wrap_around;  // Registered comparison signal

// Initialize counter to 4 (matches waveform)
initial begin
    q = 3'd4;
    wrap_around = 1'b0;
end

always @(posedge clk) begin
    // Pre-compute wrap-around condition
    wrap_around <= (q == 3'd6);
    
    if (a) begin
        // When a=1, force q to 4
        q <= 3'd4;
    end
    else begin
        // When a=0, increment with wrap-around using registered comparison
        q <= wrap_around ? 3'd0 : q + 1;
    end
end

endmodule