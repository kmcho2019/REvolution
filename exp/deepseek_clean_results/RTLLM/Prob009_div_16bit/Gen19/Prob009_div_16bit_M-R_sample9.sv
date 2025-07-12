module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Handle division by zero case first
    wire zero_divisor = (B == 8'b0);
    
    // Initialize remainder and result
    wire [15:0] quotient;
    wire [7:0] remainder;
    
    // Temporary variables for the division process
    reg [8:0] temp_rem;  // 9-bit temporary remainder (1 extra bit for carry)
    reg [15:0] temp_A;
    integer i;
    
    always @(*) begin
        temp_rem = 9'b0;
        temp_A = A;
        
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left and bring in next bit
            temp_rem = {temp_rem[7:0], temp_A[i]};
            
            // Compare and subtract if possible
            if (temp_rem >= {1'b0, B} && !zero_divisor) begin
                temp_rem = temp_rem - {1'b0, B};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end
    end
    
    // Final outputs
    assign result = zero_divisor ? 16'b0 : quotient;
    assign odd = zero_divisor ? 8'b0 : temp_rem[7:0];

endmodule