module TopModule(
    input  [7:0] a,  // 8-bit 2's complement input number
    input  [7:0] b,  // 8-bit 2's complement input number
    output [7:0] s,  // 8-bit result of the addition
    output      overflow  // indicator of signed overflow
);

    wire [7:0] sum;  // Internal wire for the sum
    wire       ovf;  // Internal wire for overflow

    // Perform the 8-bit addition
    always @(*) begin
        sum = a + b;
    end

    // Detect signed overflow based on the MSBs of inputs and result
    always @(*) begin
        if (a[7] == b[7] && a[7] != sum[7]) begin
            ovf = 1'b1;
        end else begin
            ovf = 1'b0;
        end
    end

    // Assign the internal wires to the outputs
    assign s = sum;
    assign overflow = ovf;

endmodule