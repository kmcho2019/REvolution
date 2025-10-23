module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp_product;  // Temporary product register
    reg [7:0] temp_A;  // Temporary multiplicand register
    reg [6:0] temp_B;  // Temporary multiplier register (modified Booth's representation)
    reg [2:0] counter;  // Counter for iteration
    reg sign;  // Sign bit for modified Booth's representation

    // Initialize temporary registers and counter
    initial begin
        temp_product = 0;
        temp_A = A;
        temp_B = B[7:1];  // Extract pairs of bits from multiplier
        counter = 0;
        sign = B[0];  // Determine sign bit
    end

    // Sequential logic for iteration
    always @(posedge clock) begin
        if (counter < 7) begin
            // Calculate modified Booth's value
            case (temp_B[1:0])
                2'b00: temp_product = temp_product;  // No operation
                2'b01: temp_product = temp_product + temp_A;  // Add
                2'b10: temp_product = temp_product - temp_A;  // Subtract
                2'b11: temp_product = temp_product + (temp_A << 1);  // Add with left shift
            endcase

            // Update temporary registers and counter
            temp_A = temp_A << 1;  // Left shift multiplicand
            temp_B = temp_B >> 1;  // Right shift multiplier
            counter = counter + 1;
        end
    end

    // Assign final product to output
    assign product = temp_product;

endmodule