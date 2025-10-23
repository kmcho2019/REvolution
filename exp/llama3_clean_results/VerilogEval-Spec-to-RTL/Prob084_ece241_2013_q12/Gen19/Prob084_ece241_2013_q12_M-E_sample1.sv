module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] Q;

always @(posedge clk) begin
    if (enable) begin
        Q <= {Q[6:0], S};
    end
end

wire [7:0] demux_out;
assign demux_out[0] = Q[0];
assign demux_out[1] = Q[1];
assign demux_out[2] = Q[2];
assign demux_out[3] = Q[3];
assign demux_out[4] = Q[4];
assign demux_out[5] = Q[5];
assign demux_out[6] = Q[6];
assign demux_out[7] = Q[7];

always @(*) begin
    case ({A, B, C})
        3'b000: Z = demux_out[0];
        3'b001: Z = demux_out[1];
        3'b010: Z = demux_out[2];
        3'b011: Z = demux_out[3];
        3'b100: Z = demux_out[4];
        3'b101: Z = demux_out[5];
        3'b110: Z = demux_out[6];
        3'b111: Z = demux_out[7];
        default: Z = 1'bx;
    endcase
end

endmodule