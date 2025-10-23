module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        reg [31:0] next_q;
        next_q = {q[0], q[31:1]}; // Shift right, moving MSB to LSB position and filling MSB with LSB
        next_q[31] = q[30] ^ q[21] ^ q[1] ^ q[0]; // Tap logic for MSB
        next_q[21] = q[20] ^ q[0]; // Tap logic for position 22
        next_q[1] = q[0] ^ q[30]; // Tap logic for position 2
        q <= next_q;
    end
end

endmodule