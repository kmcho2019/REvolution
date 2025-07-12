module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Number of levels needed: ceil(log2(255)) = 8
    parameter WIDTH = 255;
    parameter LEVELS = 8;
    
    // Carry-save reduction tree
    reg [7:0] sum [0:LEVELS];
    reg [7:0] carry [0:LEVELS];
    
    // Initialize first level
    integer i, j;
    always @(*) begin
        sum[0] = 0;
        carry[0] = 0;
        for (i = 0; i < WIDTH; i = i + 1) begin
            sum[0] = sum[0] + in[i];
        end
    end
    
    // Reduction levels
    generate
        for (j = 1; j <= LEVELS; j = j + 1) begin : REDUCTION_LEVELS
            always @(*) begin
                // Half the bits each level using carry-save addition
                sum[j] = sum[j-1][6:0] + carry[j-1][6:0];
                carry[j] = {1'b0, sum[j-1][7]} + {1'b0, carry[j-1][7]};
            end
        end
    endgenerate
    
    // Final addition
    assign out = sum[LEVELS] + carry[LEVELS];

endmodule