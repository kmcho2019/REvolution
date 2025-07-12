module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;
reg [511:0] next_state;

// Pipeline stages
reg [511:0] stage1 [3:0];
reg [511:0] stage2 [3:0];
reg [511:0] stage3 [3:0];

// Load data into pipeline
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
        stage1[0] <= data;
    end else begin
        // Stage 1: Compute next state bits for each group of 4 cells
        for (int i = 0; i < 128; i++) begin
            wire left, center, right;
            assign left = (i == 0) ? 1'b0 : q_reg[(i - 1) * 4 + 3];
            assign center = q_reg[i * 4 + 0];
            assign right = (i == 127) ? 1'b0 : q_reg[(i + 1) * 4 + 0];
            stage1[i + 1][0] <= left ^ right;

            assign left = (i == 0) ? 1'b0 : q_reg[(i - 1) * 4 + 2];
            assign center = q_reg[i * 4 + 1];
            assign right = (i == 127) ? 1'b0 : q_reg[(i + 1) * 4 + 1];
            stage1[i + 1][1] <= left ^ right;

            assign left = (i == 0) ? 1'b0 : q_reg[(i - 1) * 4 + 1];
            assign center = q_reg[i * 4 + 2];
            assign right = (i == 127) ? 1'b0 : q_reg[(i + 1) * 4 + 2];
            stage1[i + 1][2] <= left ^ right;

            assign left = (i == 0) ? 1'b0 : q_reg[(i - 1) * 4 + 0];
            assign center = q_reg[i * 4 + 3];
            assign right = (i == 127) ? 1'b0 : q_reg[(i + 1) * 4 + 3];
            stage1[i + 1][3] <= left ^ right;
        end

        // Stage 2: Compute next state bits for each group of 4 cells
        for (int i = 0; i < 128; i++) begin
            wire left, center, right;
            assign left = (i == 0) ? 1'b0 : stage1[i][3];
            assign center = stage1[i][0];
            assign right = (i == 127) ? 1'b0 : stage1[i + 1][0];
            stage2[i + 1][0] <= left ^ right;

            assign left = (i == 0) ? 1'b0 : stage1[i][2];
            assign center = stage1[i][1];
            assign right = (i == 127) ? 1'b0 : stage1[i + 1][1];
            stage2[i + 1][1] <= left ^ right;

            assign left = (i == 0) ? 1'b0 : stage1[i][1];
            assign center = stage1[i][2];
            assign right = (i == 127) ? 1'b0 : stage1[i + 1][2];
            stage2[i + 1][2] <= left ^ right;

            assign left = (i == 0) ? 1'b0 : stage1[i][0];
            assign center = stage1[i][3];
            assign right = (i == 127) ? 1'b0 : stage1[i + 1][3];
            stage2[i + 1][3] <= left ^ right;
        end

        // Stage 3: Compute final next state bits
        for (int i = 0; i < 128; i++) begin
            wire left, center, right;
            assign left = (i == 0) ? 1'b0 : stage2[i][3];
            assign center = stage2[i][0];
            assign right = (i == 127) ? 1'b0 : stage2[i + 1][0];
            stage3[i + 1][0] <= left ^ right;

            assign left = (i == 0) ? 1'b0 : stage2[i][2];
            assign center = stage2[i][1];
            assign right = (i == 127) ? 1'b0 : stage2[i + 1][1];
            stage3[i + 1][1] <= left ^ right;

            assign left = (i == 0) ? 1'b0 : stage2[i][1];
            assign center = stage2[i][2];
            assign right = (i == 127) ? 1'b0 : stage2[i + 1][2];
            stage3[i + 1][2] <= left ^ right;

            assign left = (i == 0) ? 1'b0 : stage2[i][0];
            assign center = stage2[i][3];
            assign right = (i == 127) ? 1'b0 : stage2[i + 1][3];
            stage3[i + 1][3] <= left ^ right;
        end

        // Update q_reg with final next state bits
        for (int i = 0; i < 128; i++) begin
            q_reg[i * 4 + 0] <= stage3[i][0];
            q_reg[i * 4 + 1] <= stage3[i][1];
            q_reg[i * 4 + 2] <= stage3[i][2];
            q_reg[i * 4 + 3] <= stage3[i][3];
        end
    end
end

assign q = q_reg;

endmodule