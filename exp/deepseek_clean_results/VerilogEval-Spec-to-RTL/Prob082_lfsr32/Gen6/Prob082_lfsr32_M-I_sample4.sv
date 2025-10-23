module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire [31:0] next_q;

always @(*) begin
    next_q[31] = q[0];
    next_q[30:22] = q[31:23];
    next_q[21] = q[22] ^ q[0];
    next_q[20:2] = q[21:3];
    next_q[1] = q[2] ^ q[0];
    next_q[0] = q[1] ^ q[0];
end

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        q <= next_q;
    end
end

endmodule