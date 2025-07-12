module TopModule(
    input [2:0] a,
    output [15:0] q
);

    parameter [15:0] OUT_0 = 16'h1232;
    parameter [15:0] OUT_1 = 16'haee0;
    parameter [15:0] OUT_2 = 16'h27d4;
    parameter [15:0] OUT_3 = 16'h5a0e;
    parameter [15:0] OUT_4 = 16'h2066;
    parameter [15:0] OUT_5 = 16'h64ce;
    parameter [15:0] OUT_6 = 16'hc526;
    parameter [15:0] OUT_7 = 16'h2f19;

    always @(*)
    begin
        case (a)
            3'b000: q = OUT_0;
            3'b001: q = OUT_1;
            3'b010: q = OUT_2;
            3'b011: q = OUT_3;
            3'b100: q = OUT_4;
            3'b101: q = OUT_5;
            3'b110: q = OUT_6;
            3'b111: q = OUT_7;
            default: q = 16'h0000;
        endcase
    end

endmodule