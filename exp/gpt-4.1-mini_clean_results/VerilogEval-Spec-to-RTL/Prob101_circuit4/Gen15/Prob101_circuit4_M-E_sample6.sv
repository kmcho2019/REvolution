module Mux4to1 (
    input wire [1:0] sel,
    input wire d0,
    input wire d1,
    input wire d2,
    input wire d3,
    output wire y
);
    // Simple combinational 4-to-1 MUX implementation
    assign y = (sel == 2'b00) ? d0 :
               (sel == 2'b01) ? d1 :
               (sel == 2'b10) ? d2 :
                                d3;
endmodule

module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire q
);
    wire [1:0] select = {b, c};

    // Assign MUX inputs such that q = b | c:
    // d0=0 (b=0,c=0 -> q=0)
    // d1=1 (b=0,c=1 -> q=1)
    // d2=1 (b=1,c=0 -> q=1)
    // d3=1 (b=1,c=1 -> q=1)
    Mux4to1 mux_inst (
        .sel(select),
        .d0(1'b0),
        .d1(1'b1),
        .d2(1'b1),
        .d3(1'b1),
        .y(q)
    );
endmodule