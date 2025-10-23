module DFF_4bit(
    input clk,
    input resetn,
    input [3:0] d,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 4'b0000;
    end else begin
        q <= d;
    end
end

endmodule

module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] q;

DFF_4bit dff(clk, resetn, {in, q[3:1]}, q);

assign out = q[0];

endmodule