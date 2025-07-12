module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    // Remainder array (17 stages x 9 bits)
    reg [8:0] remainder [0:16];
    integer i;

    always @(*) begin
        // Initialize pipeline
        remainder[16] = 9'b0;

        // Process each bit
        for (i = 15; i >= 0; i = i - 1) begin
            // Current remainder with next dividend bit
            remainder[i] = {remainder[i+1][7:0], A[i]};
            
            // Comparison and subtraction logic
            if (remainder[i] >= B) begin
                remainder[i] = remainder[i] - B;
                result[i] = 1'b1;
            end else begin
                result[i] = 1'b0;
            end
        end

        // Final remainder output (16 bits, upper 8 bits zero)
        odd = {8'b0, remainder[0][7:0]};
    end

endmodule