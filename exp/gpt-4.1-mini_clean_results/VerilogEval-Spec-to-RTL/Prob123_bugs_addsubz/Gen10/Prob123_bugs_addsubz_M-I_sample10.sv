module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    always @(*) begin
        // Perform addition or subtraction: invert b bits if do_sub=1 and add do_sub as carry_in
        out = a + (b ^ {8{do_sub}}) + do_sub;

        // Zero flag: 1 if out is zero, else 0
        result_is_zero = ~|out;
    end

endmodule