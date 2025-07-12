module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [127:0] stage1_q, stage2_q, stage3_q, stage4_q;
    reg stage1_valid, stage2_valid, stage3_valid, stage4_valid;
    reg load_d1, load_d2, load_d3;

    // Pipeline stage 1 (bits 0-127)
    wire [127:0] stage1_next;
    generate
        for (genvar i = 0; i < 128; i++) begin: stage1
            wire left = (i == 0) ? 1'b0 : (load ? data[i-1] : stage1_q[i-1]);
            wire right = (load ? data[i+1] : stage1_q[i+1]);
            assign stage1_next[i] = left ^ right;
        end
    endgenerate

    // Pipeline stage 2 (bits 128-255)
    wire [127:0] stage2_next;
    generate
        for (genvar i = 0; i < 128; i++) begin: stage2
            wire left = (load_d1 ? data[i+127] : stage2_q[i-1]);
            wire right = (load_d1 ? data[i+129] : stage2_q[i+1]);
            assign stage2_next[i] = left ^ right;
        end
    endgenerate

    // Pipeline stage 3 (bits 256-383)
    wire [127:0] stage3_next;
    generate
        for (genvar i = 0; i < 128; i++) begin: stage3
            wire left = (load_d2 ? data[i+255] : stage3_q[i-1]);
            wire right = (load_d2 ? data[i+257] : stage3_q[i+1]);
            assign stage3_next[i] = left ^ right;
        end
    endgenerate

    // Pipeline stage 4 (bits 384-511)
    wire [127:0] stage4_next;
    generate
        for (genvar i = 0; i < 128; i++) begin: stage4
            wire left = (load_d3 ? data[i+383] : stage4_q[i-1]);
            wire right = (i == 127) ? 1'b0 : (load_d3 ? data[i+385] : stage4_q[i+1]);
            assign stage4_next[i] = left ^ right;
        end
    endgenerate

    always @(posedge clk) begin
        // Pipeline control signals
        load_d1 <= load;
        load_d2 <= load_d1;
        load_d3 <= load_d2;

        // Stage 1
        if (load) begin
            stage1_q <= data[127:0];
            stage1_valid <= 1'b1;
        end else begin
            stage1_q <= stage1_next;
            stage1_valid <= 1'b1;
        end

        // Stage 2
        if (load_d1) begin
            stage2_q <= data[255:128];
        end else if (stage1_valid) begin
            stage2_q <= stage2_next;
        end
        stage2_valid <= stage1_valid;

        // Stage 3
        if (load_d2) begin
            stage3_q <= data[383:256];
        end else if (stage2_valid) begin
            stage3_q <= stage3_next;
        end
        stage3_valid <= stage2_valid;

        // Stage 4
        if (load_d3) begin
            stage4_q <= data[511:384];
        end else if (stage3_valid) begin
            stage4_q <= stage4_next;
        end
        stage4_valid <= stage3_valid;

        // Output
        if (stage4_valid) begin
            q <= {stage4_q, stage3_q, stage2_q, stage1_q};
        end
    end

endmodule