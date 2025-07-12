module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] mem;

// Memory array
always @(posedge clk) begin
    if (enable) begin
        case ({A, B, C})
            3'b000: mem[0] <= S;
            3'b001: mem[1] <= S;
            3'b010: mem[2] <= S;
            3'b011: mem[3] <= S;
            3'b100: mem[4] <= S;
            3'b101: mem[5] <= S;
            3'b110: mem[6] <= S;
            3'b111: mem[7] <= S;
            default: ;
        endcase
    end
end

// Output logic
always @(*) begin
    case ({A, B, C})
        3'b000: Z = mem[0];
        3'b001: Z = mem[1];
        3'b010: Z = mem[2];
        3'b011: Z = mem[3];
        3'b100: Z = mem[4];
        3'b101: Z = mem[5];
        3'b110: Z = mem[6];
        3'b111: Z = mem[7];
        default: Z = 1'bx;
    endcase
end

endmodule