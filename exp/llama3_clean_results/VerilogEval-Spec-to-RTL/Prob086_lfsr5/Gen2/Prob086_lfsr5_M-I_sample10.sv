module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

initial q = 5'b10001; // Initialize with a non-zero 5-bit value

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 5'b10001; // Reset q to a non-zero 5-bit value
    end else begin
        q[0] <= q[4] ^ q[2]; // Calculate new bit value
        q[4] <= q[3]; // Shift bits
        q[3] <= q[2];
        q[2] <= q[1];
        q[1] <= q[0];
    end
end

endmodule