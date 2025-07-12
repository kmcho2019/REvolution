module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output reg [N-1:0] c
);

// Define the subtractor tree structure
reg [N-1:0] level1 [1:0];
reg [N-1:0] level2 [1:0];

always @(a or b) begin
    // Level 1: Subtract MSBs
    if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin
        // Same sign subtraction
        level1[0] = a - b;
        level1[1] = {N{1'b0}};
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin
        // Same sign subtraction
        level1[0] = a - b;
        level1[1] = {N{1'b0}};
    end else begin
        // Different sign subtraction
        level1[0] = a + (~b + 1'b1);
        level1[1] = {N{1'b0}};
    end
    
    // Level 2: Subtract LSBs
    if (level1[0][N-1] == 1'b0) begin
        // Positive result
        level2[0] = level1[0];
        level2[1] = {N{1'b0}};
    end else begin
        // Negative result
        level2[0] = ~level1[0] + 1'b1;
        level2[1] = {N{1'b0}};
    end
    
    // Final result
    if (level2[0] == 0) begin
        c = {N{1'b0}};
    end else begin
        c = level2[0];
    end
end

endmodule