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
wire [2:0] select = {A, B, C};

always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

assign Z = (select == 3'b000) ? Q[0] :
           (select == 3'b001) ? Q[1] :
           (select == 3'b010) ? Q[2] :
           (select == 3'b011) ? Q[3] :
           (select == 3'b100) ? Q[4] :
           (select == 3'b101) ? Q[5] :
           (select == 3'b110) ? Q[6] :
           (select == 3'b111) ? Q[7] : 1'b0;

endmodule