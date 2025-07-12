module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

always @(*) begin
    result = 0;
    odd = A;
    for (int i = 15; i >= 0; i--) begin
        reg [8:0] temp; // Temporary variable to hold the subtraction result
        if (odd[15:8] >= B) begin
            temp = {1'b0, odd[15:8]} - {1'b0, B}; // Perform subtraction, ensuring correct bit lengths
            odd = {temp[8:1], odd[7:0]}; // Update odd, shifting in the new bit
            result[i] = 1; // Set the corresponding quotient bit
        end else begin
            odd = {1'b0, odd[15:1]}; // Shift the odd register
        end
    end
    odd = {8'b0, odd[7:0]}; // Final adjustment to odd
end

endmodule