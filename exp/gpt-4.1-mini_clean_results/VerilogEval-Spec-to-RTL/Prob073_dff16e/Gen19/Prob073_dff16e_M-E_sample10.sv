module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input  [15:0]  d,
    output reg [15:0] q
);

wire [15:0] masked_d;
wire [15:0] masked_q;

assign masked_d = {8{byteena[1]}} & d[15:8] << 8 | {8{byteena[0]}} & d[7:0];
assign masked_q = (~{8{byteena[1]}} & q[15:8]) << 8 | (~{8{byteena[0]}} & q[7:0]);

always @(posedge clk) begin
    if (!resetn)
        q <= 16'b0;
    else
        q <= ( { {8{byteena[1]}} & d[15:8], {8{byteena[0]}} & d[7:0] } ) |
             ( { {8{!byteena[1]}} & q[15:8], {8{!byteena[0]}} & q[7:0] } );
end

endmodule