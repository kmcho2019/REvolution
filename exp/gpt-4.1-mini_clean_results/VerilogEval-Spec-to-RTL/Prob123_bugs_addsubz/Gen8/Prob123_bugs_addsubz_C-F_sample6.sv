module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    reg [8:0] sum_full;  // 9 bits to capture carry-out if needed

    always @(*) begin
        sum_full = {1'b0, a} + ({1'b0, b} ^ {9{do_sub}}) + do_sub;
        out = sum_full[7:0];
        result_is_zero = ~|out;  // Reduction NOR for zero detection
    end

endmodule