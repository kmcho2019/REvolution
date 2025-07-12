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

// 8-bit shift register
always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

// Decoder to select the output
wire [7:0] decoder_out;
assign decoder_out[0] = (A == 0 && B == 0 && C == 0);
assign decoder_out[1] = (A == 0 && B == 0 && C == 1);
assign decoder_out[2] = (A == 0 && B == 1 && C == 0);
assign decoder_out[3] = (A == 0 && B == 1 && C == 1);
assign decoder_out[4] = (A == 1 && B == 0 && C == 0);
assign decoder_out[5] = (A == 1 && B == 0 && C == 1);
assign decoder_out[6] = (A == 1 && B == 1 && C == 0);
assign decoder_out[7] = (A == 1 && B == 1 && C == 1);

// Simplified multiplexer to select the output
assign Z = (decoder_out[0] ? Q[0] :
            decoder_out[1] ? Q[1] :
            decoder_out[2] ? Q[2] :
            decoder_out[3] ? Q[3] :
            decoder_out[4] ? Q[4] :
            decoder_out[5] ? Q[5] :
            decoder_out[6] ? Q[6] :
            decoder_out[7] ? Q[7] : 1'bx);

endmodule