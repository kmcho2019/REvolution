module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Define tap positions as a mask (bits 31, 21, 1, 0 since we're using 0-31 indexing)
localparam [31:0] TAP_MASK = {1'b1, 10'b0, 1'b1, 20'b0, 2'b11};

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;  // Synchronous reset to initial value
    end else begin
        // Galois LFSR implementation using mask-based XOR
        q <= {1'b0, q[31:1]} ^ (TAP_MASK & {32{q[0]}});
    end
end

endmodule