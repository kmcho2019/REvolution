module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};

    // Create 5 vectors, each is the inputs vector XNOR with one input bit, replicated to 5 bits
    wire [4:0] cmp0 = ~(inputs ^ {5{a}}); // a row
    wire [4:0] cmp1 = ~(inputs ^ {5{b}}); // b row
    wire [4:0] cmp2 = ~(inputs ^ {5{c}}); // c row
    wire [4:0] cmp3 = ~(inputs ^ {5{d}}); // d row
    wire [4:0] cmp4 = ~(inputs ^ {5{e}}); // e row

    // The output bits go from out[24] = ~(a^a) to out[0] = ~(e^e)
    // So the order is rows a->e, columns a->e, flatten row-wise with MSB first
    // out = {cmp0, cmp1, cmp2, cmp3, cmp4}, but each row needs to be reversed to match (4-j)
    // Because inputs indices and output bit indices go from a=0 ... e=4, but output bit index is (4 - i)*5 + (4 - j)
    // To fix ordering, reverse bits in each cmp*

    function [4:0] reverse5(input [4:0] in);
        integer i;
        begin
            for (i = 0; i < 5; i = i + 1)
                reverse5[i] = in[4 - i];
        end
    endfunction

    assign out = {reverse5(cmp0), reverse5(cmp1), reverse5(cmp2), reverse5(cmp3), reverse5(cmp4)};
endmodule