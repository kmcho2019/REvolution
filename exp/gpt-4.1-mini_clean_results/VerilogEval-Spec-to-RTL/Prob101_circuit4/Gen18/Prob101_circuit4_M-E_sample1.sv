module Mux4to1 (
    input wire i0,
    input wire i1,
    input wire i2,
    input wire i3,
    input wire [1:0] sel,
    output wire y
);
    assign y = (sel == 2'b00) ? i0 :
               (sel == 2'b01) ? i1 :
               (sel == 2'b10) ? i2 :
                                i3;
endmodule

module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire q
);
    // Select inputs for MUX: {b, c}
    wire [1:0] sel;
    assign sel = {b, c};

    // Multiplexer inputs to produce q = b | c
    // sel=00 -> i0=0, q=0
    // sel=01 -> i1=1, q=1
    // sel=10 -> i2=1, q=1
    // sel=11 -> i3=1, q=1
    Mux4to1 mux_inst (
        .i0(1'b0),
        .i1(1'b1),
        .i2(1'b1),
        .i3(1'b1),
        .sel(sel),
        .y(q)
    );

    // Inputs a and d are unused
endmodule