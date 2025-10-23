module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Active high sync reset to 1
    end else begin
        // Galois LFSR with taps at bits 4 and 2 (0-based)
        // XOR operation performed directly in concatenation
        q <= {q[0], q[4], q[3] ^ q[0], q[2], q[1]};
    end
end

endmodule