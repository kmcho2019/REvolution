module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    reg [23:0] temp;  // 16+8 bits for intermediate calculations
    reg [15:0] quotient;
    integer i;

    always @(*) begin
        temp = {16'b0, A};  // Initialize with dividend in lower bits
        for (i = 0; i < 16; i = i + 1) begin
            temp = temp << 1;  // Left shift
            
            if (temp[23:16] >= B) begin
                temp[23:16] = temp[23:16] - B;
                temp[0] = 1'b1;  // Set quotient bit
            end else begin
                temp[0] = 1'b0;  // Clear quotient bit
            end
        end
        
        quotient = temp[15:0];  // Final quotient is in lower 16 bits
    end

    assign result = quotient;
    assign odd = temp[23:8];  // Remainder is in upper 16 bits (only lower 8 are meaningful)

endmodule