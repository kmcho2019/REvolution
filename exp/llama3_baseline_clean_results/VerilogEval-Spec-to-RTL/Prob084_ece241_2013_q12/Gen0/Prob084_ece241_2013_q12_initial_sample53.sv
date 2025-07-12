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
wire [2:0] addr;
assign addr = {A, B, C};

always @(posedge clk) begin
    if (enable) begin
        Q <= {S, Q[7:1]};
    end
end

assign Z = (addr == 3'b000) ? Q[0] :
           (addr == 3'b001) ? Q[1] :
           (addr == 3'b010) ? Q[2] :
           (addr == 3'b011) ? Q[3] :
           (addr == 3'b100) ? Q[4] :
           (addr == 3'b101) ? Q[5] :
           (addr == 3'b110) ? Q[6] :
           (addr == 3'b111) ? Q[7] : 1'bx;

endmodule