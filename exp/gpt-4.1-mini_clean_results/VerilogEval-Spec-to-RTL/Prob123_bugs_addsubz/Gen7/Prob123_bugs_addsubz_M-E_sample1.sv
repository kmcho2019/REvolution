module Adder8 (
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [7:0] sum
);
    assign sum = a + b;
endmodule

module Subtractor8 (
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [7:0] diff
);
    assign diff = a + (~b) + 1'b1; // Two's complement subtraction
endmodule

module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] add_out;
    wire [7:0] sub_out;

    Adder8 adder_inst (
        .a(a),
        .b(b),
        .sum(add_out)
    );

    Subtractor8 subtractor_inst (
        .a(a),
        .b(b),
        .diff(sub_out)
    );

    always @(*) begin
        if (do_sub) begin
            out = sub_out;
        end else begin
            out = add_out;
        end
        if (out == 8'b0) begin
            result_is_zero = 1'b1;
        end else begin
            result_is_zero = 1'b0;
        end
    end

endmodule