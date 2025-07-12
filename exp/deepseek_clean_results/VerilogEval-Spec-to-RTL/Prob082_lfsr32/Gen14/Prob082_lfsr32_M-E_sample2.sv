module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire [31:0] next_q;

// Parallel XOR implementation
assign next_q[31] = q[0];
assign next_q[30:22] = q[31:23];
assign next_q[21] = q[22] ^ q[0];
assign next_q[20:2] = q[21:3];
assign next_q[1] = q[2] ^ q[0];
assign next_q[0] = q[1] ^ q[0];

always @(posedge clk) begin
    q <= reset ? 32'h1 : next_q;
end

endmodule