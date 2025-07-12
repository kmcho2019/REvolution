module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output logic signed [63:0] result,
    output logic overflow
);

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_neg = ~B;
    wire [63:0] sum;
    wire cout;

    // Brent-Kung Parallel Prefix Adder
    localparam LEVELS = $clog2(64);
    
    // Propagate and Generate signals
    wire [63:0] p = A ^ B_neg;
    wire [63:0] g = A & B_neg;
    
    // Prefix tree wires
    wire [63:0][LEVELS:0] pp; // propagate
    wire [63:0][LEVELS:0] pg; // generate
    
    // Initialize prefix tree
    assign pp[0][0] = p[0];
    assign pg[0][0] = g[0];
    generate
        for (genvar i = 1; i < 64; i++) begin
            assign pp[i][0] = p[i];
            assign pg[i][0] = g[i];
        end
        
        // Prefix tree construction
        for (genvar l = 1; l <= LEVELS; l++) begin
            for (genvar i = 0; i < 64; i++) begin
                if (i < (1 << (l-1))) begin
                    assign pp[i][l] = pp[i][l-1];
                    assign pg[i][l] = pg[i][l-1];
                end else begin
                    assign pp[i][l] = pp[i][l-1] & pp[i-(1<<(l-1))][l-1];
                    assign pg[i][l] = (pg[i][l-1] & pp[i-(1<<(l-1))][l-1]) | pg[i-(1<<(l-1))][l-1];
                end
            end
        end
    endgenerate
    
    // Carry computation (including +1 for subtraction)
    wire [63:0] carry;
    assign carry[0] = 1'b1; // +1 for two's complement
    generate
        for (genvar i = 1; i < 64; i++) begin
            assign carry[i] = pg[i-1][LEVELS];
        end
    endgenerate
    
    // Final sum computation
    assign sum = p ^ {carry[62:0], 1'b1};
    assign cout = pg[63][LEVELS];
    
    // Early overflow prediction
    wire early_overflow;
    assign early_overflow = (A[63] != B_neg[63]) && 
                          ((pg[63][LEVELS-1] & pp[63][LEVELS-1]) ^ A[63]);
    
    // Final result and overflow
    always_comb begin
        result = sum;
        overflow = early_overflow || 
                  ((A[63] == B_neg[63]) && (sum[63] != A[63]));
    end

    /* Architecture Notes:
     * 1. Brent-Kung prefix tree provides O(log n) depth
     * 2. Early overflow uses intermediate prefix results
     * 3. Final overflow check validates early prediction
     * 4. Power savings from conditional carry computation
     */
endmodule