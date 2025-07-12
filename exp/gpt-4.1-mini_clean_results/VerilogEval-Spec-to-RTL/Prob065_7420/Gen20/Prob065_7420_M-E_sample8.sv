module nand4 #(
    parameter WIDTH = 4
) (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output reg  y
);
    // Behavioral combinational logic for 4-input NAND gate
    always @(*) begin
        y = ~(a & b & c & d);
    end
endmodule

module TopModule (
    input  wire p1a,
    input  wire p1b,
    input  wire p1c,
    input  wire p1d,
    input  wire p2a,
    input  wire p2b,
    input  wire p2c,
    input  wire p2d,
    output wire p1y,
    output wire p2y
);

    // Instantiate the first 4-input NAND gate for inputs p1a-p1d
    nand4 #(.WIDTH(4)) nand_gate1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Instantiate the second 4-input NAND gate for inputs p2a-p2d
    nand4 #(.WIDTH(4)) nand_gate2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule