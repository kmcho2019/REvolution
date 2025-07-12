module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @ (posedge clk) begin
    if (reset) begin
        // Reset q to a simple initial state where the least significant bit is 1
        q <= 5'b00001;
    end else begin
        // Calculate the next state for each bit
        // The next state of q[4] is the XOR of q[4], q[2], and q[0]
        // The next state of q[3] is the XOR of q[3] and q[0]
        // The rest of the bits shift right
        q <= {q[3] ^ q[0], q[2] ^ q[0], q[1], q[0], 0};
    end
end

endmodule