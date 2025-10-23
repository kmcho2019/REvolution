module Mux4to1(
    input wire s0,  // Least significant select bit
    input wire s1,  // Most significant select bit
    input wire d0,
    input wire d1,
    input wire d2,
    input wire d3,
    output wire y
);
    assign y = (s1 ? (s0 ? d3 : d2) : (s0 ? d1 : d0));
endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Using b and c as select lines for Mux4to1 (s1=b, s0=c)
    // Setting inputs d0=0, d1=1, d2=1, d3=1 so output q=1 whenever b or c is 1.
    Mux4to1 mux_inst(
        .s1(b),
        .s0(c),
        .d0(1'b0),  // b=0, c=0 -> q=0
        .d1(1'b1),  // b=0, c=1 -> q=1
        .d2(1'b1),  // b=1, c=0 -> q=1
        .d3(1'b1),  // b=1, c=1 -> q=1
        .y(q)
    );
endmodule