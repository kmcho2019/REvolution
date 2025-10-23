module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [511:0] stage1_q;
    reg [511:0] stage2_q;
    
    // Clock gating
    wire clk_en = load || (|stage1_q) || (|stage2_q);
    wire gated_clk = clk & clk_en;
    
    // Combinational logic for Rule 90 - split into two stages
    // Stage 1: First 256 bits
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin: rule90_stage1
            wire left = (i == 0) ? 1'b0 : q[i-1];
            wire right = q[i+1];
            always @(*) begin
                stage1_q[i] = left ^ right;
            end
        end
        
        // Stage 2: Last 256 bits (including boundary optimization)
        for (i = 256; i < 512; i = i + 1) begin: rule90_stage2
            wire left = q[i-1];
            wire right = (i == 511) ? 1'b0 : q[i+1];
            always @(*) begin
                stage2_q[i] = left ^ right;
            end
        end
    endgenerate
    
    // Synchronous update with pipeline
    always @(posedge gated_clk) begin
        if (load) begin
            q <= data;
            stage1_q <= 0;
            stage2_q <= 0;
        end else begin
            // Pipeline update
            q <= {stage2_q[511:256], stage1_q[255:0]};
            // Shift pipeline stages
            stage1_q <= {stage2_q[255:0], stage1_q[511:256]};
            stage2_q <= {stage1_q[511:256], stage2_q[511:256]};
        end
    end

endmodule