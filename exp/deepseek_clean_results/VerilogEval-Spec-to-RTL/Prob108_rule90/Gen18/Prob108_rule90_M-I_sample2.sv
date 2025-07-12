module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Enable signal for power optimization
    wire enable = load || (|q || |(~q)); // Only enable when active
    
    // Pipelined calculation stages
    reg [127:0] stage1, stage2, stage3, stage4;
    reg [127:0] stage1_q, stage2_q, stage3_q, stage4_q;
    
    // Virtual boundary registers
    reg left_boundary = 0;
    reg right_boundary = 0;
    
    // Stage 1: Bits 0-127
    always @(*) begin
        for (integer i = 0; i < 128; i = i + 1) begin
            wire left = (i == 0) ? left_boundary : q[i-1];
            wire right = q[i+1];
            stage1[i] = left ^ right;
        end
    end
    
    // Stage 2: Bits 128-255
    always @(*) begin
        for (integer i = 128; i < 256; i = i + 1) begin
            wire left = q[i-1];
            wire right = q[i+1];
            stage2[i-128] = left ^ right;
        end
    end
    
    // Stage 3: Bits 256-383
    always @(*) begin
        for (integer i = 256; i < 384; i = i + 1) begin
            wire left = q[i-1];
            wire right = q[i+1];
            stage3[i-256] = left ^ right;
        end
    end
    
    // Stage 4: Bits 384-511
    always @(*) begin
        for (integer i = 384; i < 512; i = i + 1) begin
            wire left = q[i-1];
            wire right = (i == 511) ? right_boundary : q[i+1];
            stage4[i-384] = left ^ right;
        end
    end
    
    // Clock-gated pipeline registers
    always @(posedge clk) begin
        if (enable) begin
            stage1_q <= stage1;
            stage2_q <= stage2;
            stage3_q <= stage3;
            stage4_q <= stage4;
            
            if (load) begin
                q <= data;
            end else begin
                q <= {stage4_q, stage3_q, stage2_q, stage1_q};
            end
        end
    end

endmodule