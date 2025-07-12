module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

wire [7:0] next_upper_byte = byteena[1] ? d[15:8] : q[15:8];
wire [7:0] next_lower_byte = byteena[0] ? d[7:0] : q[7:0];
wire [15:0] next_q = {next_upper_byte, next_lower_byte};

always @(posedge clk) begin
    q <= !resetn ? 16'b0 : next_q;
end

endmodule