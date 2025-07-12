module alu #
(
    parameter WIDTH = 8
)
(
    input clk,
    input rst_n,
    input do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output reg [WIDTH-1:0] out,
    output reg result_is_zero
);

    reg [WIDTH-1:0] temp_out;
    reg [WIDTH-1:0] temp_b;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            temp_b <= 0;
            temp_out <= 0;
            out <= 0;
            result_is_zero <= 0;
        end else begin
            temp_b <= do_sub? (~b + 1) : b;
            temp_out <= a + temp_b;
            out <= temp_out;
            result_is_zero <= ~(|temp_out);
        end
    end

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    reg clk;
    reg rst_n;

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        #10;
        rst_n = 1;
    end

    alu #(.WIDTH(8)) u_alu (
      .clk(clk),
      .rst_n(rst_n),
      .do_sub(do_sub),
      .a(a),
      .b(b),
      .out(out),
      .result_is_zero(result_is_zero)
    );

endmodule