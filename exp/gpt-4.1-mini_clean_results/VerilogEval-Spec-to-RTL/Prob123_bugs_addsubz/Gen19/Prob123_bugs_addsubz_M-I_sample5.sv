module AdderSubtractor8 (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       do_sub,
    output wire [7:0] result
);
    wire [7:0] b_inverted;
    wire       cin;

    assign b_inverted = do_sub ? ~b : b;
    assign cin = do_sub;

    assign result = a + b_inverted + cin;

endmodule

module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg  [7:0] out,
    output reg        result_is_zero
);

    wire [7:0] adder_sub_out;

    AdderSubtractor8 adder_subtractor_inst (
        .a(a),
        .b(b),
        .do_sub(do_sub),
        .result(adder_sub_out)
    );

    always @(*) begin
        out = adder_sub_out;
        result_is_zero = (adder_sub_out == 8'b0) ? 1'b1 : 1'b0;
    end

endmodule