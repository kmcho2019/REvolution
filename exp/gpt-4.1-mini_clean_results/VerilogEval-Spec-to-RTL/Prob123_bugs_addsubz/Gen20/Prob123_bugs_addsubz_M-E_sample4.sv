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
    assign diff = a - b;
endmodule

module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg  [7:0] out,
    output reg        result_is_zero
);

    wire [7:0] add_res, sub_res;

    Adder8 adder_inst (
        .a(a),
        .b(b),
        .sum(add_res)
    );

    Subtractor8 subtractor_inst (
        .a(a),
        .b(b),
        .diff(sub_res)
    );

    always @(*) begin
        if (do_sub)
            out = sub_res;
        else
            out = add_res;

        result_is_zero = (out == 8'b0) ? 1'b1 : 1'b0;
    end

endmodule