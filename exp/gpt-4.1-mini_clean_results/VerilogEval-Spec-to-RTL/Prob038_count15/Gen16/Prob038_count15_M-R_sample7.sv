module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Ripple carry increment logic with continuous assignments:
wire [3:0] next_q;
wire c0, c1, c2;

// Carry chain for increment
assign c0 = q[0];
assign next_q[0] = ~q[0];
assign c1 = q[1] & c0;
assign next_q[1] = q[1] ^ c0;
assign c2 = q[2] & c1;
assign next_q[2] = q[2] ^ c1;
assign next_q[3] = q[3] ^ c2;

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else
        q <= next_q;
end

endmodule