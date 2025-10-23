module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Intermediate remainder wires (9 bits to handle carry)
    wire [8:0] rem [0:15];
    
    // Initialize first stage
    assign rem[0] = {1'b0, A[15]};
    assign result[15] = (rem[0] >= {1'b0, B});
    assign rem[1] = result[15] ? (rem[0] - {1'b0, B}) << 1 : rem[0] << 1;
    
    // Generate remaining stages
    genvar i;
    generate
        for (i = 1; i < 15; i = i + 1) begin : div_stages
            assign rem[i+1] = (rem[i] | {8'b0, A[15-i]}) >= {1'b0, B} ? 
                             ((rem[i] | {8'b0, A[15-i]}) - {1'b0, B}) << 1 : 
                             (rem[i] | {8'b0, A[15-i]}) << 1;
            assign result[15-i] = (rem[i] | {8'b0, A[15-i]}) >= {1'b0, B};
        end
    endgenerate

    // Final stage
    assign result[0] = (rem[15] | {8'b0, A[0]}) >= {1'b0, B};
    assign odd = result[0] ? (rem[15] | {8'b0, A[0]}) - {1'b0, B} : 
                            (rem[15] | {8'b0, A[0]});

endmodule