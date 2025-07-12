module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [23:0] dividend;  // 16 + 8 bits needed
reg [15:0] divisor;
reg [15:0] diff;
reg [15:0] remainder;

always @(*) begin
    // Initialize
    dividend = {8'b0, A};
    divisor = {8'b0, B};
    result = 16'b0;
    remainder = 16'b0;
    
    // Check for division by zero
    if (B == 8'b0) begin
        result = 16'hFFFF;  // Max value as error indicator
        odd = 16'hFFFF;
    end
    else begin
        // Iteration 0
        diff = dividend[23:8] - divisor;
        result[15] = ~diff[15];
        dividend[23:8] = diff[15] ? dividend[23:8] : diff;
        dividend = dividend << 1;
        
        // Iteration 1
        diff = dividend[23:8] - divisor;
        result[14] = ~diff[15];
        dividend[23:8] = diff[15] ? dividend[23:8] : diff;
        dividend = dividend << 1;
        
        // Iteration 2
        diff = dividend[23:8] - divisor;
        result[13] = ~diff[15];
        dividend[23:8] = diff[15] ? dividend[23:8] : diff;
        dividend = dividend << 1;
        
        // Iteration 3
        diff = dividend[23:8] - divisor;
        result[12] = ~diff[15];
        dividend[23:8] = diff[15] ? dividend[23:8] : diff;
        dividend = dividend << 1;
        
        // Iteration 4
        diff = dividend[23:8] - divisor;
        result[11] = ~diff[15];
        dividend[23:8] = diff[15] ? dividend[23:8] : diff;
        dividend = dividend << 1;
        
        // Iteration 5
        diff = dividend[23:8] - divisor;
        result[10] = ~diff[15];
        dividend[23:8] = diff[15] ? dividend[23:8] : diff;
        dividend = dividend << 1;
        
        // Iteration 6
        diff = dividend[23:8] - divisor;
        result[9] = ~diff[15];
        dividend[23:8] = diff[15] ? dividend[23:8] : diff;
        dividend = dividend << 1;
        
        // Iteration 7
        diff = dividend[23:8] - divisor;
        result[8] = ~diff[15];
        dividend[23:8] = diff[15] ? dividend[23:8] : diff;
        dividend = dividend << 1;
        
        // Iteration 8
        diff = dividend[23:8] - divisor;
        result[7] = ~diff[15];
        dividend[23:8] = diff[15] ? dividend[23:8] : diff;
        dividend = dividend << 1;
        
        // Iteration 9
        diff = dividend[23:8] - divisor;
        result[6] = ~diff[15];
        dividend[23:8] = diff[15] ? dividend[23:8] : diff;
        dividend = dividend << 1;
        
        // Iteration 10
        diff = dividend[23:8] - divisor;
        result[5] = ~diff[15];
        dividend[23:8] = diff[15] ? dividend[23:8] : diff;
        dividend = dividend << 1;
        
        // Iteration 11
        diff = dividend[23:8] - divisor;
        result[4] = ~diff[15];
        dividend[23:8] = diff[15] ? dividend[23:8] : diff;
        dividend = dividend << 1;
        
        // Iteration 12
        diff = dividend[23:8] - divisor;
        result[3] = ~diff[15];
        dividend[23:8] = diff[15] ? dividend[23:8] : diff;
        dividend = dividend << 1;
        
        // Iteration 13
        diff = dividend[23:8] - divisor;
        result[2] = ~diff[15];
        dividend[23:8] = diff[15] ? dividend[23:8] : diff;
        dividend = dividend << 1;
        
        // Iteration 14
        diff = dividend[23:8] - divisor;
        result[1] = ~diff[15];
        dividend[23:8] = diff[15] ? dividend[23:8] : diff;
        dividend = dividend << 1;
        
        // Iteration 15
        diff = dividend[23:8] - divisor;
        result[0] = ~diff[15];
        dividend[23:8] = diff[15] ? dividend[23:8] : diff;
        
        odd = {8'b0, dividend[23:16]};  // Proper 8-bit remainder extended to 16-bits
    end
end

endmodule