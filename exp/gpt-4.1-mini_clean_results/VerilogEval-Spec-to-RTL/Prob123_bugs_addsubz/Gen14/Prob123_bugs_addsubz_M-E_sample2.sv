module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_xor; // operand b xor'ed with do_sub (0 for add, 1 for subtract)
    wire [8:0] sum_ext; // extended sum to capture carry out if any

    assign b_xor = b ^ {8{do_sub}}; 
    assign sum_ext = {1'b0, a} + {1'b0, b_xor} + do_sub;

    always @(*) begin
        out = sum_ext[7:0];
        result_is_zero = (out == 8'b0);
    end

endmodule