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
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

reg [7:0] decoder_out;
always @(*) begin
    decoder_out = 8'b0;
    case ({A, B, C})
        3'b000: decoder_out[0] = 1'b1;
        3'b001: decoder_out[1] = 1'b1;
        3'b010: decoder_out[2] = 1'b1;
        3'b011: decoder_out[3] = 1'b1;
        3'b100: decoder_out[4] = 1'b1;
        3'b101: decoder_out[5] = 1'b1;
        3'b110: decoder_out[6] = 1'b1;
        3'b111: decoder_out[7] = 1'b1;
        default: decoder_out = 8'b0;
    endcase
end

always @(*) begin
    Z = (decoder_out[0] && Q[0]) || (decoder_out[1] && Q[1]) || (decoder_out[2] && Q[2]) ||
        (decoder_out[3] && Q[3]) || (decoder_out[4] && Q[4]) || (decoder_out[5] && Q[5]) ||
        (decoder_out[6] && Q[6]) || (decoder_out[7] && Q[7]);
end

endmodule