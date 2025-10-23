module addsub_zflag #
(
    parameter WIDTH = 8
)
(
    input clk,
    input do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output reg [WIDTH-1:0] out,
    output reg result_is_zero
);

    // Use a clock gating technique to reduce switching activity
    reg clk_gated;
    always @(*) begin
        if (a != a || b != b || do_sub != do_sub) begin
            clk_gated = clk;
        end else begin
            clk_gated = 1'b0;
        end
    end

    // Use a carry-lookahead adder for efficient addition and subtraction
    wire [WIDTH-1:0] b_mux;
    assign b_mux = do_sub? (~b + 1) : b;

    wire [WIDTH-1:0] add_result;
    assign add_result = a + b_mux;

    // Minimize logic gates in zero flag generation
    assign result_is_zero = ~(|add_result);

    // Use a clock-enabled always block to reduce switching activity
    always @(posedge clk_gated) begin
        out <= add_result;
    end

endmodule

module TopModule (
    input clk,
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    addsub_zflag #(.WIDTH(8)) u_addsub (
       .clk(clk),
       .do_sub(do_sub),
       .a(a),
       .b(b),
       .out(out),
       .result_is_zero(result_is_zero)
    );

endmodule