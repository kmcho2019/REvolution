module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire cd_xor = c ^ d;
    wire cd_xnor = ~(c ^ d);

    // 4:1 MUX using a,b as selector
    // For ab=00 or 11, output is cd_xnor
    // For ab=01 or 10, output is cd_xor

    wire out0 = cd_xnor; // ab=00
    wire out1 = cd_xor;  // ab=01
    wire out2 = cd_xor;  // ab=11
    wire out3 = cd_xnor; // ab=10

    wire [1:0] sel = {a, b};

    assign out = (sel == 2'b00) ? out0 :
                 (sel == 2'b01) ? out1 :
                 (sel == 2'b11) ? out2 :
                                  out3;

endmodule