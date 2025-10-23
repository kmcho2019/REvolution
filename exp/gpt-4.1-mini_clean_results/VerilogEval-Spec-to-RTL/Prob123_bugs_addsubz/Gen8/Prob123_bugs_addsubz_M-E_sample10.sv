module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] add_res;
    wire [7:0] sub_res;

    // Simple adder
    assign add_res = a + b;

    // Two's complement subtraction: a + (~b + 1)
    assign sub_res = a + (~b) + 1;

    always @(*) begin
        if (do_sub) begin
            out = sub_res;
            result_is_zero = (sub_res == 8'b0);
        end else begin
            out = add_res;
            result_is_zero = (add_res == 8'b0);
        end
    end

endmodule