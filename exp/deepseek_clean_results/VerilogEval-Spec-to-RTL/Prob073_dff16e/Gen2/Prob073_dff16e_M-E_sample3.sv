module ByteRegister (
    input clk,
    input resetn,
    input enable,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 8'b0;
    end else if (enable) begin
        q <= d;
    end
end

endmodule

module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

ByteRegister upper_byte (
    .clk(clk),
    .resetn(resetn),
    .enable(byteena[1]),
    .d(d[15:8]),
    .q(q[15:8])
);

ByteRegister lower_byte (
    .clk(clk),
    .resetn(resetn),
    .enable(byteena[0]),
    .d(d[7:0]),
    .q(q[7:0])
);

endmodule