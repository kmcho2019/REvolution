module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] next_q;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        next_q = {q[0], q[31:1]}; // Shift right
        next_q[31] = q[0] ^ q[21] ^ q[1] ^ q[0]; // Update the MSB based on taps
        next_q[21] = q[0] ^ q[21] ^ q[1] ^ q[0]; // Update the tap position 21
        next_q[1] = q[0] ^ q[21] ^ q[1] ^ q[0]; // Update the tap position 1
        next_q[0] = q[0] ^ q[21] ^ q[1] ^ q[0]; // Update the tap position 0
        q <= next_q;
    end
end

endmodule