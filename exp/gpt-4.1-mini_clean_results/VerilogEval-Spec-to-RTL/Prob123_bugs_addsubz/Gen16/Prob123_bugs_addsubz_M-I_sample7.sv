module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_xored;
    wire [8:0] sum_ext;

    assign b_xored = b ^ {8{do_sub}};
    assign sum_ext = {1'b0, a} + {1'b0, b_xored} + do_sub;

    always @(*) begin
        out = sum_ext[7:0];
        result_is_zero = ~|out;
    end

endmodule