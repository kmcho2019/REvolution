module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= {q[0],                     // New MSB from old LSB
              q[31:23],                 // Unchanged upper bits
              q[22] ^ q[0],             // Tap at bit 22 (0-based 21)
              q[21:3],                  // Middle unchanged bits
              q[2] ^ q[0],             // Tap at bit 2 (0-based 1)
              q[1] ^ q[0]};            // Tap at bit 1 (0-based 0)
    end
end

endmodule