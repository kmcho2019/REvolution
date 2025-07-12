module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    always @(*) begin
        // Perform addition or subtraction using XOR and carry-in
        out = a + (b ^ {8{do_sub}}) + do_sub;
        // Assign zero flag by reduction NOR of output bits
        result_is_zero = ~|out;
    end

endmodule