module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [511:0] stage1;
    reg [511:0] stage2;
    
    // Clock gating signal
    reg update_en;
    always @(posedge clk) begin
        update_en <= load || (|stage1); // Enable if load or any cell active
    end

    // Stage 1: Compute first 256 XORs
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin: stage1_rule90
            wire left = (i == 0) ? 1'b0 : q[i-1];
            wire right = q[i+1];
            always @(*) begin
                stage1[i] = left ^ right;
            end
        end
    endgenerate

    // Stage 2: Compute remaining 256 XORs
    generate
        for (i = 256; i < 512; i = i + 1) begin: stage2_rule90
            wire left = q[i-1];
            wire right = (i == 511) ? 1'b0 : q[i+1];
            always @(*) begin
                stage2[i] = left ^ right;
            end
        end
    endgenerate

    // Combine stages
    wire [511:0] next_q = {stage2[511:256], stage1[255:0]};

    // Synchronous update with clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (update_en) begin
            q <= next_q;
        end
    end

endmodule