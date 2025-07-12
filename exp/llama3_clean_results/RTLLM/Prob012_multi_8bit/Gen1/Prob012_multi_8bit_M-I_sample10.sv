module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    // Initialize the product to zero
    reg [15:0] temp_product;
    assign product = temp_product;

    // Pipeline the multiplication into stages
    reg [7:0] A_pipe [7:0];
    reg [15:0] product_pipe [7:0];

    always @(*) begin
        // Stage 0: Initialize A_pipe with A
        A_pipe[0] = A;
        product_pipe[0] = 0;

        // Stages 1-7: Perform multiplication
        for (int i = 1; i < 8; i++) begin
            // Shift A left by one bit for the next stage
            A_pipe[i] = A_pipe[i-1] << 1;
            // If the current bit of the multiplier is set, add the shifted A to the product
            if (B[i-1])
                product_pipe[i] = product_pipe[i-1] + A_pipe[i-1];
            else
                product_pipe[i] = product_pipe[i-1];
        end

        // Final product
        temp_product = product_pipe[7];
    end

endmodule