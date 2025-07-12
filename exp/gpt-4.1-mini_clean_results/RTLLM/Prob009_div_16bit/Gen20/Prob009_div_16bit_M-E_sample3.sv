module div_16bit (
    input  wire [15:0] A,        // Dividend
    input  wire [7:0]  B,        // Divisor
    output reg  [15:0] result,   // Quotient
    output reg  [15:0] odd       // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First division step outputs
    wire [7:0] q_high;
    wire [7:0] r_high;

    // Second division step outputs
    wire [7:0] q_low;
    wire [7:0] r_low;

    // Latch inputs combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Divider sub-module: divides 8-bit dividend by 8-bit divisor, output 8-bit quotient and remainder
    // Implemented combinationally via shift-subtract in generate loop
    function [15:0] div8;
        input [15:0] dividend; // upper 8 bits dividend[15:8], lower 8 bits dividend[7:0]
        input [7:0] divisor;
        integer i;
        reg [8:0] remainder;
        reg [7:0] quotient;
        begin
            remainder = 0;
            quotient = 0;
            for (i=7; i>=0; i=i-1) begin
                remainder = {remainder[7:0], dividend[i]};
                if (remainder >= divisor) begin
                    remainder = remainder - divisor;
                    quotient[i] = 1'b1;
                end else begin
                    quotient[i] = 1'b0;
                end
            end
            div8 = {quotient, remainder[7:0]};
        end
    endfunction

    always @(*) begin
        // Step 1: divide upper 8 bits of A by B
        {q_high, r_high} = div8(a_reg[15:8], b_reg);
        // Step 2: concatenate remainder of step 1 with lower 8 bits of A, then divide by B
        {q_low, r_low} = div8({r_high, a_reg[7:0]}, b_reg);

        // Combine quotient parts
        result = {q_high, q_low};
        // Final remainder
        odd = {8'd0, r_low};
    end

endmodule