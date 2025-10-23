module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 5'b00001; // Reset to 1
    end else begin
        q[4] <= q[3] ^ q[0]; // Tap positions 5 and 3
        q[3] <= q[2] ^ q[0]; // Tap position 3
        q[2] <= q[1];
        q[1] <= q[0];
        q[0] <= 0; // Since we're shifting right, the LSB is always 0
    end
end

endmodule