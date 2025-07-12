module Mux4to1 (
    input  wire d0,
    input  wire d1,
    input  wire d2,
    input  wire d3,
    input  wire [1:0] sel,
    output wire y
);
    // 4-to-1 Multiplexer combinational logic
    assign y = (sel == 2'b00) ? d0 :
               (sel == 2'b01) ? d1 :
               (sel == 2'b10) ? d2 :
                                d3;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);

    wire [1:0] sel;
    assign sel = {a, d}; // Use inputs a and d as select lines

    wire common = b | c;

    // All mux inputs connected to b | c, so output always equals b|c
    Mux4to1 mux_inst (
        .d0(common),
        .d1(common),
        .d2(common),
        .d3(common),
        .sel(sel),
        .y(q)
    );

endmodule