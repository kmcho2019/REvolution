module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Early termination for zero divisor (top-level optimization)
    wire zero_divisor = (B == 8'b0);
    assign result = zero_divisor ? 16'b0 : quotient_bits;
    assign odd = zero_divisor ? A[7:0] : remainder;

    // Main division logic (only active when B != 0)
    wire [15:0] quotient_bits;
    wire [7:0] remainder;
    
    // Shared resources
    wire [8:0] cmp_in;
    wire cmp_out;
    wire [7:0] sub_out;
    
    // Optimized division steps using carry-save approach
    reg [8:0] partial_remainder = 0;
    reg [15:0] quotient = 0;
    integer i;
    
    always @(*) begin
        partial_remainder = {1'b0, A[15]};
        quotient = 0;
        
        for (i = 0; i < 16; i = i + 1) begin
            // Shared comparator
            cmp_in = partial_remainder;
            cmp_out = (cmp_in >= {1'b0, B});
            
            // Shared subtractor
            sub_out = cmp_in[7:0] - B;
            
            // Update results
            quotient[15-i] = cmp_out;
            partial_remainder = cmp_out ? {sub_out, (i < 15) ? A[14-i] : 1'b0} 
                                       : {cmp_in[7:0], (i < 15) ? A[14-i] : 1'b0};
        end
    end
    
    assign quotient_bits = quotient;
    assign remainder = partial_remainder[7:0];

endmodule