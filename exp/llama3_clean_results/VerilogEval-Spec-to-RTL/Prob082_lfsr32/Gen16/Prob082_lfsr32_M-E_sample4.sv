module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] next_state;
reg tap_xor;

always @(*) begin
    tap_xor = q[31] ^ q[21] ^ q[1] ^ q[0];
    next_state = {tap_xor, q[31:1]};
end

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= next_state;
    end
end

endmodule