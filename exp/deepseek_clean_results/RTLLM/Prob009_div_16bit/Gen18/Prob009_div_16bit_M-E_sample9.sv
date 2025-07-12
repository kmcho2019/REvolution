module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Early zero-divisor detection
    wire zero_divisor = (B == 8'b0);
    
    // Parallel comparison decision tree
    wire [15:0] cmp_results;
    wire [15:0][8:0] partial_remainders;
    
    // Phase 1: Parallel comparison computation
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : cmp_tree
            // Get current partial remainder (9-bit)
            wire [8:0] current_rem = (i == 15) ? {1'b0, A[15]} : 
                                    {partial_remainders[i+1][7:0], A[i]};
            
            // Parallel comparison
            assign cmp_results[i] = (current_rem >= {1'b0, B});
            
            // Carry-select subtraction
            wire [8:0] rem_sub = current_rem - {1'b0, B};
            wire [8:0] rem_noop = current_rem;
            
            // Select remainder based on comparison
            assign partial_remainders[i] = cmp_results[i] ? rem_sub : rem_noop;
        end
    endgenerate
    
    // Phase 2: Result generation
    reg [15:0] res;
    always @(*) begin
        if (zero_divisor) begin
            res = 16'b0;
        end else begin
            for (int j = 0; j < 16; j = j + 1) begin
                res[j] = cmp_results[j];
            end
        end
    end
    
    assign result = res;
    assign odd = zero_divisor ? 8'b0 : partial_remainders[0][7:0];

endmodule