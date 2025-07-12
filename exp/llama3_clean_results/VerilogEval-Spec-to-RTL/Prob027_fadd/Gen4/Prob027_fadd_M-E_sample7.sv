module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

assign {cout, sum} = (a & b & cin) ? 4'b111 :
                     (a & b & ~cin) ? 4'b110 :
                     (a & ~b & cin) ? 4'b110 :
                     (~a & b & cin) ? 4'b110 :
                     (a & ~b & ~cin) ? 4'b011 :
                     (~a & b & ~cin) ? 4'b011 :
                     (~a & ~b & cin) ? 4'b011 :
                     (~a & ~b & ~cin) ? 4'b000 : 4'b000;

endmodule