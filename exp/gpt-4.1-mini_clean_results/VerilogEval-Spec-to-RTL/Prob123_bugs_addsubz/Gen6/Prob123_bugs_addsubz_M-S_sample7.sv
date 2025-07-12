module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_xor = b ^ {8{do_sub}};
    wire [8:0] sum_full = a + b_xor + do_sub;

    always @(*) begin
        out = sum_full[7:0];
        result_is_zero = ~|out;
    end

endmodule