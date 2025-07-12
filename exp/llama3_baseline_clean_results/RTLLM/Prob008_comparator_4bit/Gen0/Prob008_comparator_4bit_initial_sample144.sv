module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

// Perform subtraction A - B and generate borrow
reg [3:0] diff;
reg borrow;

always @(*) begin
    // Initialize borrow to 0
    borrow = 0;
    
    // Perform subtraction
    diff = A - B;
    
    // Check for borrow
    if (A < B) begin
        borrow = 1;
    end
end

// Determine output signals based on subtraction result and borrow
always @(*) begin
    // Check if A is less than B (borrow occurred)
    if (borrow == 1) begin
        A_greater = 0;
        A_equal = 0;
        A_less = 1;
    end
    // Check if A is greater than B (no borrow and non-zero result)
    else if (diff!= 0) begin
        A_greater = 1;
        A_equal = 0;
        A_less = 0;
    end
    // If A equals B (result is zero)
    else begin
        A_greater = 0;
        A_equal = 1;
        A_less = 0;
    end
end

endmodule