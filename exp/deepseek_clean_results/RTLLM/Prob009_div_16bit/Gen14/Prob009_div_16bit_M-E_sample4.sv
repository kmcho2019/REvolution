module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Serial processing registers
    reg [15:0] quotient;
    reg [8:0] current_remainder; // Extra bit for comparison
    reg [3:0] bit_counter;
    reg done;

    // Combinational processing (unrolled loop)
    always @(*) begin
        // Initialize
        quotient = 16'b0;
        current_remainder = 9'b0;
        done = 1'b0;
        bit_counter = 4'd0;

        // Process all bits (unrolled)
        for (integer i = 15; i >= 0; i = i - 1) begin
            if (!done) begin
                // Shift remainder and append next bit
                current_remainder = {current_remainder[7:0], A[i]};
                
                // Compare and subtract
                if (current_remainder >= {1'b0, B}) begin
                    current_remainder = current_remainder - B;
                    quotient[i] = 1'b1;
                end else begin
                    quotient[i] = 1'b0;
                end

                // Early termination check
                if (current_remainder == 9'b0 && i > 0) begin
                    // Shift remaining bits directly to quotient
                    quotient[i-1:0] = A[i-1:0];
                    done = 1'b1;
                end
            end
        end
    end

    // Output assignments
    assign result = quotient;
    assign odd = current_remainder[7:0];

endmodule