module addsub_zflag #
(
    parameter WIDTH = 8
)
(
    input do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output reg [WIDTH-1:0] out,
    output reg result_is_zero
);

    wire [WIDTH-1:0] b_comp;
    assign b_comp = ~b + 1;

    wire [WIDTH-1:0] b_mux;
    assign b_mux = do_sub? b_comp : b;

    always @(*) begin
        out = a + b_mux;
        result_is_zero = (out == 0);
    end

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    addsub_zflag #(.WIDTH(8)) u_addsub (
       .do_sub(do_sub),
       .a(a),
       .b(b),
       .out(out),
       .result_is_zero(result_is_zero)
    );

endmodule