module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_xor;
    wire [8:0] sum_full;

    assign b_xor = b ^ {8{do_sub}};  // Conditional inversion of B
    assign sum_full = {1'b0, a} + {1'b0, b_xor} + do_sub;  // Add A + B_xor + carry_in

    always @(*) begin
        out = sum_full[7:0];
        result_is_zero = ~|out;  // Zero flag using reduction NOR
    end

endmodule