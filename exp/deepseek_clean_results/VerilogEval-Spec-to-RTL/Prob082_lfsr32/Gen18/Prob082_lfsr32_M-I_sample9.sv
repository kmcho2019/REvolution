module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire tap_xor_22 = q[22] ^ q[0];
wire tap_xor_2 = q[2] ^ q[0];
wire tap_xor_1 = q[1] ^ q[0];

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q[31:23] <= q[30:22];
        q[22] <= tap_xor_22;
        q[21:3] <= q[20:2];
        q[2] <= tap_xor_2;
        q[1] <= tap_xor_1;
        q[0] <= q[31];
    end
end

endmodule