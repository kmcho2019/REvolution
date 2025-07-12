module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] mem [7:0];

always @(posedge clk) begin
    if (enable) begin
        for (int i = 7; i > 0; i--) begin
            mem[i] <= mem[i-1];
        end
        mem[0] <= {7'b0, S};
    end
end

always @(*) begin
    case ({A, B, C})
        3'b000: Z = mem[0][0];
        3'b001: Z = mem[1][0];
        3'b010: Z = mem[2][0];
        3'b011: Z = mem[3][0];
        3'b100: Z = mem[4][0];
        3'b101: Z = mem[5][0];
        3'b110: Z = mem[6][0];
        3'b111: Z = mem[7][0];
        default: Z = 1'bx;
    endcase
end

endmodule