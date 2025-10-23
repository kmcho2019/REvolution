module adder_subtractor(
    input logic do_sub,
    input [7:0] a,
    input [7:0] b,
    output logic [7:0] out
);

    logic [7:0] add_result;
    logic [7:0] sub_result;

    assign add_result = a + b;
    assign sub_result = a - b;

    always_comb begin
        if (do_sub) begin
            out = sub_result;
        end else begin
            out = add_result;
        end
    end

endmodule

module zero_flag_generator(
    input [7:0] out,
    output logic result_is_zero
);

    assign result_is_zero = ~(|out);

endmodule

module TopModule(
    input logic do_sub,
    input [7:0] a,
    input [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    logic [7:0] add_sub_out;

    adder_subtractor u_add_sub(
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(add_sub_out)
    );

    zero_flag_generator u_zero_flag(
        .out(add_sub_out),
        .result_is_zero(result_is_zero)
    );

    assign out = add_sub_out;

endmodule