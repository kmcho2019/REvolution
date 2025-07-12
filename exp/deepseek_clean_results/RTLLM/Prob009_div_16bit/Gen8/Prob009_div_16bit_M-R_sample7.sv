module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Intermediate wires for each bit stage
    wire [8:0] rem [0:15];  // 9-bit remainders for each stage
    
    // First stage (MSB)
    assign rem[15] = (A[15] ? {1'b0, A[15]} : 9'b0);
    assign result[15] = rem[15] >= {1'b0, B};
    
    // Generate remaining stages
    genvar i;
    generate
        for (i = 14; i >= 0; i = i - 1) begin : div_stages
            wire [8:0] prev_rem = rem[i+1];
            wire [8:0] extended = {prev_rem[7:0], A[i]};
            
            assign rem[i] = (extended >= {1'b0, B}) ? 
                          (extended - {1'b0, B}) : extended;
            assign result[i] = extended >= {1'b0, B};
        end
    endgenerate
    
    // Final remainder output with zero-division check
    assign odd = (B == 8'b0) ? 8'b0 : rem[0][7:0];

endmodule