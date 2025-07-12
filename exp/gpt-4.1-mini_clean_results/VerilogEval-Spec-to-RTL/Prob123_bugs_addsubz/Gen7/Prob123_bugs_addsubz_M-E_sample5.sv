module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] add_res;
    wire [7:0] sub_res;

    assign add_res = a + b;
    assign sub_res = a - b;

    always @(*) begin
        out = do_sub ? sub_res : add_res;
        result_is_zero = ~|out;
    end

endmodule