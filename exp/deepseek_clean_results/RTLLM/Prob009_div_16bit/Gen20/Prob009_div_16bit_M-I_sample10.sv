module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    reg [15:0] quotient;
    reg [7:0] remainder;
    wire [8:0] diff;
    wire cmp_result;
    integer i;

    // Zero-division check and early termination
    assign odd = (B == 8'b0) ? 16'b0 : {8'b0, remainder};
    
    // Carry-lookahead subtraction and comparison
    assign diff = {remainder, A[15]} - {1'b0, B};
    assign cmp_result = ~diff[8];  // MSB indicates borrow
    
    always @(*) begin
        remainder = 8'b0;
        quotient = 16'b0;
        
        if (B != 8'b0) begin
            for (i = 15; i >= 0; i = i - 1) begin
                // Update remainder and quotient
                remainder = cmp_result ? diff[7:0] : {remainder[6:0], A[i]};
                quotient[i] = cmp_result;
                
                // Precompute next subtraction
                // (This happens automatically through continuous assignment)
            end
        end
    end

    assign result = quotient;

endmodule