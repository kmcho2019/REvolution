module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (upper 8 bits zero)
);

    // Combinational "input registers"
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic using restoring division inside procedural block
    always @(*) begin
        integer i;
        reg [7:0] remainder;
        reg [15:0] quotient;
        reg [8:0] rem_temp;

        remainder = 8'd0;
        quotient = 16'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left and bring in the next bit from dividend
            rem_temp = {remainder, a_reg[i]};
            if (rem_temp >= b_reg) begin
                rem_temp = rem_temp - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
            remainder = rem_temp[7:0];
        end

        result = quotient;
        odd = {8'd0, remainder};
    end

endmodule