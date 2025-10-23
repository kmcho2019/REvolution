module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

reg [7:0] Q;

always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

wire [7:0] sel;
assign sel[0] = ~A & ~B & ~C;
assign sel[1] = ~A & ~B & C;
assign sel[2] = ~A & B & ~C;
assign sel[3] = ~A & B & C;
assign sel[4] = A & ~B & ~C;
assign sel[5] = A & ~B & C;
assign sel[6] = A & B & ~C;
assign sel[7] = A & B & C;

assign Z = (sel[0] & Q[0]) | (sel[1] & Q[1]) | (sel[2] & Q[2]) | (sel[3] & Q[3]) | 
           (sel[4] & Q[4]) | (sel[5] & Q[5]) | (sel[6] & Q[6]) | (sel[7] & Q[7]);

endmodule