module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        q <= {
            q[0],            // MSB gets feedback (position 5)
            q[4],            // Simple shift
            q[3] ^ q[0],     // Tap at position 3
            q[2],            // Simple shift
            q[1]             // Simple shift
        };
    end
end

endmodule