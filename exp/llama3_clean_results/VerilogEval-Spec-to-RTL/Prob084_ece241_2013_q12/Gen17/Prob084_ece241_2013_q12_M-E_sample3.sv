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

// Decoder to select which flip-flop's output to use as the output Z
wire [7:0] decoder_out;
assign decoder_out[0] = ~(A | B | C);
assign decoder_out[1] = ~(A | B) & C;
assign decoder_out[2] = ~(A | C) & B;
assign decoder_out[3] = ~(A) & B & C;
assign decoder_out[4] = ~A & B & ~C;
assign decoder_out[5] = ~A & ~B & C;
assign decoder_out[6] = ~A & ~B & ~C;
assign decoder_out[7] = A & ~B & ~C;

// Output Z is selected from the outputs of the flip-flops based on the decoded signal
assign Z = (decoder_out[0] & Q[0]) | (decoder_out[1] & Q[1]) | (decoder_out[2] & Q[2]) | 
           (decoder_out[3] & Q[3]) | (decoder_out[4] & Q[4]) | (decoder_out[5] & Q[5]) | 
           (decoder_out[6] & Q[6]) | (decoder_out[7] & Q[7]);

// Shift register implementation
always @(posedge clk) begin
    if (enable) begin
        Q <= {Q[6:0], S};
    end
end

endmodule