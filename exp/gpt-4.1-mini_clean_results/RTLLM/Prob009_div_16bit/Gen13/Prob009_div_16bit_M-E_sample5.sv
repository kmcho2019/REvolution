module div_16bit (
    input  wire [15:0] A,         // Dividend
    input  wire [7:0]  B,         // Divisor
    output reg  [15:0] result,    // Quotient
    output reg  [15:0] odd        // Remainder (zero-extended to 16 bits)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Two-stage division combinational block
    always @(*) begin
        // Variables for first division stage
        reg [7:0] upper_dividend;
        reg [7:0] q_high;
        reg [7:0] r_high;

        // Variables for second division stage
        reg [15:0] combined_low_dividend;
        reg [7:0] q_low;
        reg [7:0] r_final;

        // First, divide upper 8 bits of dividend by divisor
        upper_dividend = a_reg[15:8];

        if (b_reg == 0) begin
            // Handle divide by zero gracefully: zero quotient and remainder
            q_high = 8'd0;
            r_high = 8'd0;
            q_low  = 8'd0;
            r_final = 8'd0;
        end else begin
            if (upper_dividend >= b_reg) begin
                q_high = upper_dividend / b_reg;   // Quotient upper 8 bits
                r_high = upper_dividend % b_reg;   // Remainder upper 8 bits
            end else begin
                q_high = 8'd0;
                r_high = upper_dividend;
            end

            // Combine remainder from first division with lower 8 bits of dividend
            combined_low_dividend = {r_high, a_reg[7:0]};

            // Divide combined value by divisor for lower quotient and remainder
            if (combined_low_dividend >= b_reg) begin
                q_low = combined_low_dividend / b_reg;
                r_final = combined_low_dividend % b_reg;
            end else begin
                q_low = 8'd0;
                r_final = combined_low_dividend[7:0]; // remainder fits in 8 bits
            end
        end

        // Concatenate the two quotient parts
        result = {q_high, q_low};
        odd    = {8'd0, r_final};  // zero-extend remainder to 16 bits
    end

endmodule