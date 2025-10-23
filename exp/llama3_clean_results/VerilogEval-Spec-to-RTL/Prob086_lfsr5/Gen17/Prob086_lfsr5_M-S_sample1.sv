module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001; // Initialize with LSB as 1
    end else begin
        q[4] <= q[0] ^ q[2]; // Feedback for the MSB based on a typical maximal-length LFSR polynomial
        q[3:0] <= {q[3:0], 0}; // Shift the rest of the bits to the right
    end
end

endmodule