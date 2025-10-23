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
    wire load_or_advance = load || !load; // Simplified for this case
    
    // Combinational Rule 90 logic with pipelining
    genvar i;
    generate
        // First segment (0-127)
        for (i = 0; i < 128; i = i + 1) begin: rule90_seg1
            wire left = (i == 0) ? 1'b0 : q[i-1];
            wire right = (i == 127) ? q[128] : q[i+1];
            assign next_q[i] = left ^ right;
        end
        
        // Second segment (128-255)
        for (i = 128; i < 256; i = i + 1) begin: rule90_seg2
            wire left = (i == 128) ? q[127] : q[i-1];
            wire right = (i == 255) ? q[256] : q[i+1];
            assign next_q[i] = left ^ right;
        end
        
        // Third segment (256-383)
        for (i = 256; i < 384; i = i + 1) begin: rule90_seg3
            wire left = (i == 256) ? q[255] : q[i-1];
            wire right = (i == 383) ? q[384] : q[i+1];
            assign next_q[i] = left ^ right;
        end
        
        // Fourth segment (384-511)
        for (i = 384; i < 512; i = i + 1) begin: rule90_seg4
            wire left = (i == 384) ? q[383] : q[i-1];
            wire right = (i == 511) ? 1'b0 : q[i+1];
            assign next_q[i] = left ^ right;
        end
    endgenerate
    
    // Pipelined synchronous update with clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            stage1 <= 128'b0;
            stage2 <= 128'b0;
            stage3 <= 128'b0;
        end else if (load_or_advance) begin
            // Pipeline stage 1 (0-127)
            stage1 <= next_q[127:0];
            
            // Pipeline stage 2 (128-255)
            stage2 <= next_q[255:128];
            
            // Pipeline stage 3 (256-383)
            stage3 <= next_q[383:256];
            
            // Final stage (384-511) and previous stages
            q <= {next_q[511:384], stage3, stage2, stage1};
        end
    end

endmodule