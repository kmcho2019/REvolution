module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [127:0] stage1, stage2, stage3;
    reg [511:0] next_q;
    
    // Boundary registers (always 0)
    reg left_bound = 1'b0;
    reg right_bound = 1'b0;
    
    // Pipeline computation
    always @(*) begin
        // Stage 1: Compute first 128 bits
        for (integer i = 0; i < 128; i++) begin
            wire left = (i == 0) ? left_bound : q[i-1];
            wire right = q[i+1];
            stage1[i] = left ^ right;
        end
        
        // Stage 2: Compute next 128 bits (using stage1 results)
        for (integer i = 128; i < 256; i++) begin
            wire left = q[i-1];
            wire right = q[i+1];
            stage2[i-128] = left ^ right;
        end
        
        // Stage 3: Compute next 128 bits (using stage2 results)
        for (integer i = 256; i < 384; i++) begin
            wire left = q[i-1];
            wire right = q[i+1];
            stage3[i-256] = left ^ right;
        end
        
        // Final stage: Compute last 128 bits
        for (integer i = 384; i < 512; i++) begin
            wire left = q[i-1];
            wire right = (i == 511) ? right_bound : q[i+1];
            next_q[i] = left ^ right;
        end
        
        // Combine pipeline results
        next_q[127:0] = stage1;
        next_q[255:128] = stage2;
        next_q[383:256] = stage3;
    end
    
    // Synchronous update with pipeline
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            // Reset pipeline on load
            stage1 <= 128'b0;
            stage2 <= 128'b0;
            stage3 <= 128'b0;
        end else begin
            q <= next_q;
        end
    end

endmodule