module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

always @(*) begin
    case ({a,b,c,d})
        4'b0000: q = 1'b1; // time 0-15ns
        4'b0001: q = 1'b0; // 20ns
        4'b0010: q = 1'b0; // 25ns
        4'b0011: q = 1'b1; // 30ns
        4'b0100: q = 1'b0; // 35ns
        4'b0101: q = 1'b1; // 40ns
        4'b0110: q = 1'b1; // 45ns
        4'b0111: q = 1'b0; // 50ns
        4'b1000: q = 1'b0; // 55ns
        4'b1001: q = 1'b1; // 60ns
        4'b1010: q = 1'b1; // 65ns
        4'b1011: q = 1'b0; // 70ns
        4'b1100: q = 1'b1; // 75ns
        4'b1101: q = 1'b0; // 80ns
        4'b1110: q = 1'b0; // 85ns
        4'b1111: q = 1'b1; // 90ns
        default: q = 1'b0;
    endcase
end

endmodule