module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;  // Synchronous reset to initial value
    end else begin
        // Galois LFSR with taps at positions 32, 22, 2, and 1
        q <= {
            q[0],                     // New MSB (position 32)
            q[31:23],                 // Untapped positions 31-23
            q[22] ^ q[0],             // Tapped position 22
            q[21:3],                  // Untapped positions 21-3
            q[2] ^ q[0],              // Tapped position 2
            q[1] ^ q[0]               // Tapped position 1
        };
    end
end

endmodule