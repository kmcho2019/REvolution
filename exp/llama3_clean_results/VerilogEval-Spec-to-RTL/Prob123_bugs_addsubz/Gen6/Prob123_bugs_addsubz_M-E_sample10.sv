module Adder(
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output reg is_zero
);

    always @(*) begin
        out = a + b;
        is_zero = (out == 8'd0) ? 1'b1 : 1'b0;
    end

endmodule

module Subtractor(
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output reg is_zero
);

    always @(*) begin
        out = a - b;
        is_zero = (out == 8'd0) ? 1'b1 : 1'b0;
    end

endmodule

module ControlModule(
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output reg result_is_zero
);

    wire [7:0] add_out;
    wire [7:0] sub_out;
    wire add_is_zero;
    wire sub_is_zero;

    Adder adder_inst(
        .a(a),
        .b(b),
        .out(add_out),
        .is_zero(add_is_zero)
    );

    Subtractor subtractor_inst(
        .a(a),
        .b(b),
        .out(sub_out),
        .is_zero(sub_is_zero)
    );

    always @(*) begin
        if (do_sub) begin
            out = sub_out;
            result_is_zero = sub_is_zero;
        end else begin
            out = add_out;
            result_is_zero = add_is_zero;
        end
    end

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output reg result_is_zero
);

    ControlModule control_module_inst(
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

endmodule