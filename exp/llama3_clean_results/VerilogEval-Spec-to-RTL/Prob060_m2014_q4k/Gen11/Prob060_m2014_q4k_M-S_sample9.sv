// Simplified TopModule with Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] q;

always @(posedge clk) begin
    if (!resetn) q <= 0;
    else q <= {q[2:0], in};
end

assign out = q[3];

endmodule