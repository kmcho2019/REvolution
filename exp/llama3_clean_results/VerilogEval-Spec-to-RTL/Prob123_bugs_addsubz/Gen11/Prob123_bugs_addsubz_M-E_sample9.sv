module add_sub_zero_flag #
(
    parameter WIDTH = 8
)
(
    input logic do_sub,
    input logic [WIDTH-1:0] a,
    input logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] out,
    output logic result_is_zero
);

    // Perform addition or subtraction based on control signal
    always_comb begin
        if (do_sub) begin
            out = a - b;
        end else begin
            out = a + b;
        end
        // Generate zero flag
        result_is_zero = (out == 0);
    end

endmodule

// Example usage
module TopModule (
    input logic do_sub,
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    add_sub_zero_flag #(.WIDTH(8)) u_add_sub_zero_flag (
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

endmodule