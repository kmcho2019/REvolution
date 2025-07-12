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

wire [7:0] and_terms;
assign and_terms[0] = ~A & ~B & ~C & Q[0];
assign and_terms[1] = ~A & ~B & C & Q[1];
assign and_terms[2] = ~A & B & ~C & Q[2];
assign and_terms[3] = ~A & B & C & Q[3];
assign and_terms[4] = A & ~B & ~C & Q[4];
assign and_terms[5] = A & ~B & C & Q[5];
assign and_terms[6] = A & B & ~C & Q[6];
assign and_terms[7] = A & B & C & Q[7];

assign Z = and_terms[0] | and_terms[1] | and_terms[2] | and_terms[3] | and_terms[4] | and_terms[5] | and_terms[6] | and_terms[7];

endmodule