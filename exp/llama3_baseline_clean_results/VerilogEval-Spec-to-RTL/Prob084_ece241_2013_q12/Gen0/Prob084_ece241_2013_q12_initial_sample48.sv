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

wire [2:0] sel;
assign sel = {A, B, C};

wire [7:0] out;
assign out[0] = Q[0];
assign out[1] = Q[1];
assign out[2] = Q[2];
assign out[3] = Q[3];
assign out[4] = Q[4];
assign out[5] = Q[5];
assign out[6] = Q[6];
assign out[7] = Q[7];

assign Z = (sel == 3'b000) ? out[0] :
           (sel == 3'b001) ? out[1] :
           (sel == 3'b010) ? out[2] :
           (sel == 3'b011) ? out[3] :
           (sel == 3'b100) ? out[4] :
           (sel == 3'b101) ? out[5] :
           (sel == 3'b110) ? out[6] :
           (sel == 3'b111) ? out[7] : 1'b0;

endmodule