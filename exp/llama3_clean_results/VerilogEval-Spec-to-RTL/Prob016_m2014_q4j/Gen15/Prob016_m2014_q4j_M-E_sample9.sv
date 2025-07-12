// Wallace tree adder module
module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    // Compute partial sums and carries
    wire [3:0] ps, pc;
    assign ps = x ^ y;
    assign pc = x & y;
    
    // First reduction stage
    wire [2:0] ps1, pc1;
    assign ps1[0] = ps[0] ^ ps[1];
    assign pc1[0] = pc[0] | (ps[0] & ps[1]);
    assign ps1[1] = ps[2] ^ ps[3];
    assign pc1[1] = pc[2] | (ps[2] & ps[3]);
    assign ps1[2] = 1'b0; // unused
    assign pc1[2] = 1'b0; // unused
    
    // Second reduction stage
    wire [1:0] ps2, pc2;
    assign ps2[0] = ps1[0] ^ ps1[1];
    assign pc2[0] = pc1[0] | (ps1[0] & ps1[1]);
    assign ps2[1] = 1'b0; // unused
    assign pc2[1] = 1'b0; // unused
    
    // Final addition stage
    assign sum[0] = ps2[0];
    assign sum[1] = ps1[0] ^ pc1[0];
    assign sum[2] = ps1[1] ^ pc1[1];
    assign sum[3] = ps[3] ^ pc[3];
    assign sum[4] = pc2[0]; // overflow bit
endmodule