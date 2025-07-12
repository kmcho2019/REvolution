module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_xor;   // Conditionally inverted B
    wire [8:0] sum;     // 9-bit sum to hold carry out

    assign b_xor = b ^ {8{do_sub}};       // If do_sub=1 invert b, else keep b
    assign sum = {1'b0, a} + {1'b0, b_xor} + do_sub; // Add a + b_xor + carry_in (do_sub)

    always @(*) begin
        out = sum[7:0];                    // Lower 8 bits are the result
        result_is_zero = ~|out;            // Zero flag: reduction NOR of out bits
    end

endmodule