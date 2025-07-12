module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // No need for input latching always block; directly use inputs in combinational logic

    integer i;
    reg [7:0] remainder;    // 8-bit remainder register during calculation
    reg [15:0] quotient;    // 16-bit quotient register during calculation
    reg [8:0] rem_ext;      // 9-bit extended remainder for subtraction

    always @(*) begin
        remainder = 8'd0;
        quotient = 16'd0;

        for (i = 15; i >= 0; i = i -1) begin
            // Shift remainder left by 1 and append current bit of dividend
            rem_ext = {remainder, A[i]};

            // Compare with divisor
            if (rem_ext >= {1'b0, B}) begin
                remainder = rem_ext - {1'b0, B};
                quotient[i] = 1'b1;
            end else begin
                remainder = rem_ext[7:0];
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'd0, remainder};  // zero-extend remainder to 16 bits
    end

endmodule