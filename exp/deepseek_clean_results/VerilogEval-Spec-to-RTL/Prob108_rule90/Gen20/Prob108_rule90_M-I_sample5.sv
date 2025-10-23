module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [127:0] stage1, stage2, stage3;
    wire [511:0] next_q;
    wire clk_en = load | (|q) | (|next_q); // Clock gating condition
    
    // Clock gating
    wire gated_clk;
    BUFGCE clk_gate (
        .I(clk),
        .CE(clk_en),
        .O(gated_clk)
    );
    
    // Combinational logic in 4 stages
    genvar i;
    generate
        // Stage 1: bits 0-127
        for (i = 0; i < 128; i = i + 1) begin: stage1_gen
            wire left = (i == 0) ? 1'b0 : q[i-1];
            wire right = q[i+1];
            assign next_q[i] = left ^ right;
        end
        
        // Stage 2: bits 128-255
        for (i = 128; i < 256; i = i + 1) begin: stage2_gen
            wire left = q[i-1];
            wire right = q[i+1];
            assign next_q[i] = left ^ right;
        end
        
        // Stage 3: bits 256-383
        for (i = 256; i < 384; i = i + 1) begin: stage3_gen
            wire left = q[i-1];
            wire right = q[i+1];
            assign next_q[i] = left ^ right;
        end
        
        // Stage 4: bits 384-511
        for (i = 384; i < 512; i = i + 1) begin: stage4_gen
            wire left = q[i-1];
            wire right = (i == 511) ? 1'b0 : q[i+1];
            assign next_q[i] = left ^ right;
        end
    endgenerate
    
    // Pipelined synchronous update
    always @(posedge gated_clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule