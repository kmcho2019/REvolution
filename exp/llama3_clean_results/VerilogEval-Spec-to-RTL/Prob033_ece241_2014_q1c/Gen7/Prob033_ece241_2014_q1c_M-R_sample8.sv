module TopModule(
    input  [7:0] a,  // 8-bit 2's complement input number
    input  [7:0] b,  // 8-bit 2's complement input number
    output [7:0] s,  // 8-bit result of the addition
    output      overflow  // indicator of signed overflow
);

    reg [7:0] sum;  // internal signal for the sum
    reg        ovf;  // internal signal for overflow

    // Use always block for addition and overflow detection
    always @(*) begin
        sum = a + b;
        ovf = (a[7] == b[7]) && (a[7]!= sum[7]);
    end

    // Assign internal signals to outputs
    assign s = sum;
    assign overflow = ovf;

endmodule