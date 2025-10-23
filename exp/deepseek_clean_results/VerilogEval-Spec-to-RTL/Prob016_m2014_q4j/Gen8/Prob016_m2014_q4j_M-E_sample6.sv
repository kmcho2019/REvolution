module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [3:0] P, G;
    wire [3:0] C;
    wire skip_condition;
    
    // Compute propagate and generate signals
    assign P = x ^ y;  // Propagate
    assign G = x & y;  // Generate
    
    // Skip condition (when all bits propagate)
    assign skip_condition = &P;
    
    // Carry computation with skip logic
    assign C[0] = G[0] | (P[0] & 1'b0);  // Initial carry-in is 0
    assign C[1] = skip_condition ? C[0] : (G[1] | (P[1] & C[0]));
    assign C[2] = skip_condition ? C[0] : (G[2] | (P[2] & C[1]));
    assign C[3] = skip_condition ? C[0] : (G[3] | (P[3] & C[2]));
    
    // Sum computation
    assign sum[0] = P[0] ^ 1'b0;
    assign sum[1] = P[1] ^ C[0];
    assign sum[2] = P[2] ^ C[1];
    assign sum[3] = P[3] ^ C[2];
    assign sum[4] = C[3];  // Overflow bit
endmodule