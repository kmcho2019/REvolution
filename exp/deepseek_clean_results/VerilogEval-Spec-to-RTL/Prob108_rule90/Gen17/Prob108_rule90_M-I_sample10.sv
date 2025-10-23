module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [127:0] stage1, stage2, stage3;
    wire [511:0] next_q;
    
    // Clock gating signals
    wire update_en = ~load;
    
    // Segment 0 (bits 0-127)
    genvar i;
    generate
        for (i = 0; i < 128; i = i + 1) begin: seg0
            wire left = (i == 0) ? 1'b0 : q[i-1];
            wire right = (i == 127) ? q[128] : q[i+1];
            assign next_q[i] = left ^ right;
        end
        
        // Segment 1 (bits 128-255)
        for (i = 128; i < 256; i = i + 1) begin: seg1
            wire left = (i == 128) ? q[127] : q[i-1];
            wire right = (i == 255) ? q[256] : q[i+1];
            assign next_q[i] = left ^ right;
        end
        
        // Segment 2 (bits 256-383)
        for (i = 256; i < 384; i = i + 1) begin: seg2
            wire left = (i == 256) ? q[255] : q[i-1];
            wire right = (i == 383) ? q[384] : q[i+1];
            assign next_q[i] = left ^ right;
        end
        
        // Segment 3 (bits 384-511)
        for (i = 384; i < 512; i = i + 1) begin: seg3
            wire left = (i == 384) ? q[383] : q[i-1];
            wire right = (i == 511) ? 1'b0 : q[i+1];
            assign next_q[i] = left ^ right;
        end
    endgenerate
    
    // Pipelined update with clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            stage1 <= 128'b0;
            stage2 <= 128'b0;
            stage3 <= 128'b0;
        end else if (update_en) begin
            // Pipeline stage 1
            stage1 <= next_q[127:0];
            
            // Pipeline stage 2
            stage2 <= {next_q[255:128], stage1[127:0]};
            
            // Pipeline stage 3
            stage3 <= {next_q[383:256], stage2[127:0]};
            
            // Final output
            q <= {next_q[511:384], stage3[127:0]};
        end
    end

endmodule