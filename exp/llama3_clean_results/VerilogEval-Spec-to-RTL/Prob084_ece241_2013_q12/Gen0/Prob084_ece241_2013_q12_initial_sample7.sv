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
wire [2:0] selector;
assign selector = {A, B, C};

always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

assign Z = (selector == 3'b000) ? Q[0] :
           (selector == 3'b001) ? Q[1] :
           (selector == 3'b010) ? Q[2] :
           (selector == 3'b011) ? Q[3] :
           (selector == 3'b100) ? Q[4] :
           (selector == 3'b101) ? Q[5] :
           (selector == 3'b110) ? Q[6] :
           (selector == 3'b111) ? Q[7] : 1'bx;

endmodule