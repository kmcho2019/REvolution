module TopModule(
    input [2:0] a,
    output [15:0] q
    );

always @(*)
    case (a)
        3'b000: q = 16'h1232;
        3'b001: q = 16'haee0;
        3'b002: q = 16'h27d4;
        3'b003: q = 16'h5a0e;
        3'b004: q = 16'h2066;
        3'b005: q = 16'h64ce;
        3'b006: q = 16'hc526;
        3'b007: q = 16'h2f19;
        default: q = 16'h0000;
    endcase

endmodule