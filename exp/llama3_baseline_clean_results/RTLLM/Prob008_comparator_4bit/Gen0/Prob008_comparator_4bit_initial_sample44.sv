module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal signals for borrow and result
reg [3:0] result;
reg [3:0] borrow;

// Perform subtraction and borrow propagation
always @(A or B) begin
    // Initialize borrow to 0
    borrow[0] = 0;
    
    // Perform subtraction and borrow propagation for each bit
    for (int i = 0; i < 4; i++) begin
        if (i == 0) begin
            // Most significant bit
            result[i] = A[i] - B[i];
            borrow[i+1] = (A[i] < B[i]);
        end else begin
            // Less significant bits
            result[i] = A[i] - B[i] - borrow[i];
            borrow[i+1] = (A[i] - borrow[i] < B[i]);
        end
    end
end

// Determine output values based on result and borrow
always @(result or borrow) begin
    // Check for borrow (A < B)
    if (borrow[3] == 1) begin
        A_less = 1;
        A_greater = 0;
        A_equal = 0;
    end else begin
        // Check if result is non-zero (A > B)
        if (result != 0) begin
            A_less = 0;
            A_greater = 1;
            A_equal = 0;
        end else begin
            // A and B are equal
            A_less = 0;
            A_greater = 0;
            A_equal = 1;
        end
    end
end

endmodule