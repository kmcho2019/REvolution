module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Early zero-divisor detection
    wire zero_divisor = (B == 8'b0);
    
    // Intermediate wires for each bit stage (8-bit remainder + carry)
    wire [7:0] rem [0:15];  // 8-bit remainders
    wire carry [0:15];      // Carry bits
    
    // First stage (MSB)
    assign {carry[15], rem[15]} = {1'b0, A[15]};
    assign result[15] = ({carry[15], rem[15]} >= {1'b0, B}) && !zero_divisor;
    
    // Generate remaining stages
    genvar i;
    generate
        for (i = 14; i >= 0; i = i - 1) begin : div_stages
            // Shift remainder and add next bit
            wire [8:0] extended = {rem[i+1], A[i]};
            
            // Optimized comparison and subtraction
            assign {carry[i], rem[i]} = 
                (extended >= {1'b0, B} && !zero_divisor) ? 
                (extended - {1'b0, B}) : extended;
                
            assign result[i] = (extended >= {1'b0, B}) && !zero_divisor;
        end
    endgenerate
    
    // Final remainder output
    assign odd = zero_divisor ? 8'b0 : rem[0];

endmodule