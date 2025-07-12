module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        // Initialize the LFSR with the MSB set to 1 when reset is high
        q <= 5'b10000;
    end else begin
        // Calculate the next state by shifting the bits to the right and XORing
        // the bits at positions 5 and 3 with the LSB (q[0])
        q[4] <= q[3];
        q[3] <= q[2] ^ q[0];
        q[2] <= q[1];
        q[1] <= q[0];
        q[0] <= q[4] ^ q[3] ^ q[0];
    end
end

endmodule