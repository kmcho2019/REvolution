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
        next_q[0] = q[0] ^ q[31] ^ q[21] ^ q[1]; // Tap positions
        q <= next_q;
    end
end

endmodule