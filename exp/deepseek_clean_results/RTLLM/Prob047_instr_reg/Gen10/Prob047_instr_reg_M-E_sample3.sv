module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Pipeline stage 1: Instruction capture
    reg [7:0] ins_p1, ins_p2;
    reg stage1_valid;

    // Pipeline stage 2: Output registers
    reg [7:0] ins_p1_q, ins_p2_q;
    reg stage2_valid;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Clear both pipeline stages
            {ins_p1, ins_p2} <= 16'h0;
            {ins_p1_q, ins_p2_q} <= 16'h0;
            stage1_valid <= 1'b0;
            stage2_valid <= 1'b0;
        end else begin
            // Stage 1: Capture new instructions
            if (fetch[0]) ins_p1 <= data;
            if (fetch[1]) ins_p2 <= data;
            stage1_valid <= |fetch;

            // Stage 2: Register outputs
            if (stage1_valid) begin
                ins_p1_q <= ins_p1;
                ins_p2_q <= ins_p2;
            end
            stage2_valid <= stage1_valid;
        end
    end

    // Output assignments from stage 2 registers
    always @(*) begin
        if (stage2_valid) begin
            ins = ins_p1_q[7:5];
            ad1 = ins_p1_q[4:0];
            ad2 = ins_p2_q;
        end else begin
            {ins, ad1, ad2} = 16'h0;
        end
    end

endmodule