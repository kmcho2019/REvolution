module div_16bit (
    input  wire [15:0] A,    // Dividend
    input  wire [7:0]  B,    // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    integer i;
    reg [7:0] rem;        // 8-bit remainder register
    reg [15:0] quotient;  // 16-bit quotient register
    reg [8:0] cmp;        // 9-bit comparator: remainder concatenated with dividend bit

    always @(*) begin
        rem = 8'd0;
        quotient = 16'd0;
        for (i = 15; i >= 0; i = i - 1) begin
            // Concatenate current remainder and next dividend bit
            cmp = {rem, A[i]};
            if (cmp >= B) begin
                rem = cmp - B;       // Update remainder
                quotient[i] = 1'b1; // Set quotient bit
            end else begin
                rem = cmp[7:0];     // Update remainder (lower 8 bits of cmp)
                quotient[i] = 1'b0; // Clear quotient bit
            end
        end
        result = quotient;
        odd = {8'd0, rem}; // zero upper 8 bits, remainder in lower 8 bits
    end

endmodule