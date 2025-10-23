module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Division by zero detection
    wire zero_divisor = (B == 8'b0);
    
    // Working remainder (17 bits: 16 + carry)
    wire [16:0] working_rem;
    
    // Shared subtractor/comparator
    wire [8:0] current_chunk;
    wire [8:0] sub_result = current_chunk - {1'b0, B};
    wire chunk_ge = (current_chunk >= {1'b0, B});
    
    // Initialize with dividend
    assign working_rem = {1'b0, A};
    
    // Generate all quotient bits in parallel with shared logic
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : bit_stages
            // Select appropriate 9-bit chunk from working remainder
            assign current_chunk = (i == 15) ? {1'b0, working_rem[16:9]} :
                                 {working_rem[i+7:i], working_rem[i-1]};
            
            // Quotient bit generation
            assign result[i] = zero_divisor ? 1'b0 : chunk_ge;
            
            // Remainder update logic
            wire [16:0] next_rem;
            if (i == 15) begin
                assign next_rem = chunk_ge ? 
                    {sub_result, working_rem[8:0]} : 
                    {current_chunk[7:0], working_rem[8:0]};
            end else begin
                assign next_rem = chunk_ge ? 
                    {working_rem[16:i+8], sub_result, working_rem[i-1:0]} : 
                    working_rem;
            end
        end
    endgenerate
    
    // Final remainder output
    assign odd = zero_divisor ? 8'b0 : working_rem[7:0];

endmodule