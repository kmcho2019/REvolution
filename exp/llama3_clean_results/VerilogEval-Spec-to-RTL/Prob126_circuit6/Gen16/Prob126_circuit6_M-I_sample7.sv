module TopModule(
    input [2:0] a,
    output [15:0] q
);

    localparam Q_000 = 16'h1232;
    localparam Q_001 = 16'haee0;
    localparam Q_010 = 16'h27d4;
    localparam Q_011 = 16'h5a0e;
    localparam Q_100 = 16'h2066;
    localparam Q_101 = 16'h64ce;
    localparam Q_110 = 16'hc526;
    localparam Q_111 = 16'h2f19;

    always_comb begin
        case (a)
            3'b000: q = Q_000;
            3'b001: q = Q_001;
            3'b010: q = Q_010;
            3'b011: q = Q_011;
            3'b100: q = Q_100;
            3'b101: q = Q_101;
            3'b110: q = Q_110;
            3'b111: q = Q_111;
            default: q = Q_000; // Default case
        endcase
    end

endmodule