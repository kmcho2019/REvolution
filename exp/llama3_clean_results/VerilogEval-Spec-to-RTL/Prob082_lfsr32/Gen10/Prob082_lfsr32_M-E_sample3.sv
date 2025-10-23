module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] next_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        reg msb;
        msb = q[0] ^ q[1] ^ q[21] ^ q[31];
        next_state = {msb, q[31:1]};
        q <= next_state;
    end
end

endmodule