module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Early zero-division handling
    wire zero_divisor = (B == 8'b0);
    
    // Intermediate wires for each bit stage (now 8-bit)
    wire [7:0] rem [0:15];  // Remainders for each stage
    
    // First stage (MSB)
    wire [7:0] first_ext = zero_divisor ? 8'b0 : {7'b0, A[15]};
    wire first_ge = (first_ext >= B) & ~zero_divisor;
    assign rem[15] = first_ge ? (first_ext - B) : first_ext;
    assign result[15] = first_ge;
    
    // Generate remaining stages with shared subtractor logic
    genvar i;
    generate
        for (i = 14; i >= 0; i = i - 1) begin : div_stages
            wire [7:0] prev_rem = rem[i+1];
            wire [7:0] extended = zero_divisor ? 8'b0 : {prev_rem[6:0], A[i]};
            wire current_ge = (extended >= B) & ~zero_divisor;
            
            // Shared subtraction logic
            wire [7:0] sub_result = extended - B;
            assign rem[i] = current_ge ? sub_result : extended;
            assign result[i] = current_ge;
        end
    endgenerate
    
    // Final remainder output
    assign odd = zero_divisor ? 8'b0 : rem[0];

endmodule