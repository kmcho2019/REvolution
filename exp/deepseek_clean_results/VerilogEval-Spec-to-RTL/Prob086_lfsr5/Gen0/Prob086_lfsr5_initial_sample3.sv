module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Reset to 1
    end
    else begin
        q <= {q[0] ^ q[2], q[4], q[3], q[2], q[1]};
        // New MSB is XOR of LSB and tap bit q[2]
        // Other bits shift right
    end
end

endmodule