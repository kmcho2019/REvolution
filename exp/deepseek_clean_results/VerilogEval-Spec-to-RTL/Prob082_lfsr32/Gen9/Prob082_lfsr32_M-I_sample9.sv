module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        // Group taps by proximity to minimize XOR depth
        q <= {q[0], 
              q[31:23], 
              q[22] ^ q[0],  // Tap at 22
              q[21:3], 
              {q[2] ^ q[0],  // Tap at 2
               q[1] ^ q[0]}}; // Tap at 1
    end
end

endmodule