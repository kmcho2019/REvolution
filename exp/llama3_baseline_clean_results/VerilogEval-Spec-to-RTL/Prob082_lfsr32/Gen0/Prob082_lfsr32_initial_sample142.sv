module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        reg [31:0] next_q;
        next_q[31:1] = q[30:0]; // Shift right
        next_q[0] = q[0] ^ q[21] ^ q[1] ^ q[31]; // XOR with taps
        q <= next_q;
    end
end

endmodule