module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    quotient = 0;
    remainder = A;
    
    if (B == 0) begin
        // Handle division by zero
        result = 16'hFFFF;
        odd = 16'hFFFF;
    end else begin
        reg [3:0] d3, d2, d1, d0;
        reg [7:0] temp;
        
        // Divide the 16-bit dividend into four 4-bit segments
        d3 = A[15:12];
        d2 = A[11:8];
        d1 = A[7:4];
        d0 = A[3:0];
        
        // Perform subtract-and-shift operations for each 4-bit segment
        for (int i = 3; i >= 0; i--) begin
            case (i)
                3: temp = (d3 >= B) ? (d3 - B) : d3;
                2: temp = (d2 >= B) ? (d2 - B) : d2;
                1: temp = (d1 >= B) ? (d1 - B) : d1;
                0: temp = (d0 >= B) ? (d0 - B) : d0;
            endcase
            
            // Update the quotient and remainder
            if (temp < B) begin
                quotient[15 - (i * 4)] = 1'b0;
            end else begin
                quotient[15 - (i * 4)] = 1'b1;
            end
            
            // Shift the result of the subtraction to the right by 4 bits
            remainder = {remainder[15:4], temp[3:0]};
        end
        
        // Assign the final quotient and remainder
        result = quotient;
        odd = remainder;
    end
end

endmodule