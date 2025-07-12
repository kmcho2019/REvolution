module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    always @(*) begin
        // Perform addition or subtraction using two's complement method
        out = a + (b ^ {8{do_sub}}) + do_sub;
        // Correct zero flag detection using reduction NOR
        result_is_zero = ~|out;
    end

endmodule