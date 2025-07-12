module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Special case handling for divide by zero
    wire zero_divisor = (B == 8'b0);
    
    // Binary search implementation
    wire [7:0] quotient_guess [0:7];
    wire [15:0] product [0:7];
    wire [7:0] remainder_guess [0:7];
    wire [7:0] valid_quotient [0:7];
    wire [7:0] valid_remainder [0:7];
    
    // Initial search range: 0-255
    assign quotient_guess[0] = 8'd128;
    assign product[0] = quotient_guess[0] * B;
    assign remainder_guess[0] = A - product[0];
    
    // Binary search steps
    assign valid_quotient[0] = (product[0] <= A) ? quotient_guess[0] : 8'd0;
    assign valid_remainder[0] = (product[0] <= A) ? remainder_guess[0] : A[7:0];
    
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : search_steps
            // Calculate next guess based on previous result
            wire [7:0] step = (8'd1 << (7-i));
            assign quotient_guess[i] = valid_quotient[i-1] + 
                                     ((valid_remainder[i-1] >= B) ? step : 8'd0);
            
            // Calculate product and remainder
            assign product[i] = quotient_guess[i] * B;
            assign remainder_guess[i] = A - product[i];
            
            // Validate and store best result
            assign valid_quotient[i] = (product[i] <= A) ? quotient_guess[i] : valid_quotient[i-1];
            assign valid_remainder[i] = (product[i] <= A) ? remainder_guess[i] : valid_remainder[i-1];
        end
    endgenerate
    
    // Final results
    assign result = zero_divisor ? 16'hFFFF : {8'd0, valid_quotient[7]};
    assign odd = zero_divisor ? 8'hFF : valid_remainder[7];

endmodule