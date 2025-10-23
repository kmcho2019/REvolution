module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Pipeline registers between stages
    reg [15:0] adda_s1, addb_s1;
    reg        en_s1;
    reg        carry_in_s1;

    reg [15:0] adda_s2, addb_s2;
    reg        en_s2;
    reg        carry_in_s2;

    reg [15:0] adda_s3, addb_s3;
    reg        en_s3;
    reg        carry_in_s3;

    reg [15:0] adda_s4, addb_s4;
    reg        en_s4;
    reg        carry_in_s4;

    // Sum and carry signals computed combinationally per stage
    wire [16:0] sum_stage1;
    wire [16:0] sum_stage2;
    wire [16:0] sum_stage3;
    wire [16:0] sum_stage4;

    // Stage 1 inputs latch
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_s1      <= 16'd0;
            addb_s1      <= 16'd0;
            en_s1        <= 1'b0;
            carry_in_s1  <= 1'b0;
        end else if (i_en) begin
            adda_s1      <= adda[15:0];
            addb_s1      <= addb[15:0];
            en_s1        <= i_en;
            carry_in_s1  <= 1'b0; // initial carry-in zero for LSB stage
        end else begin
            en_s1 <= 1'b0; // disable pipeline if no input enable
        end
    end

    assign sum_stage1 = adda_s1 + addb_s1 + carry_in_s1;

    // Stage 2 registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_s2      <= 16'd0;
            addb_s2      <= 16'd0;
            en_s2        <= 1'b0;
            carry_in_s2  <= 1'b0;
        end else begin
            adda_s2      <= adda[31:16];
            addb_s2      <= addb[31:16];
            en_s2        <= en_s1;
            carry_in_s2  <= sum_stage1[16]; // carry out from stage 1
        end
    end

    assign sum_stage2 = adda_s2 + addb_s2 + carry_in_s2;

    // Stage 3 registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_s3      <= 16'd0;
            addb_s3      <= 16'd0;
            en_s3        <= 1'b0;
            carry_in_s3  <= 1'b0;
        end else begin
            adda_s3      <= adda[47:32];
            addb_s3      <= addb[47:32];
            en_s3        <= en_s2;
            carry_in_s3  <= sum_stage2[16]; // carry out from stage 2
        end
    end

    assign sum_stage3 = adda_s3 + addb_s3 + carry_in_s3;

    // Stage 4 registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_s4      <= 16'd0;
            addb_s4      <= 16'd0;
            en_s4        <= 1'b0;
            carry_in_s4  <= 1'b0;
        end else begin
            adda_s4      <= adda[63:48];
            addb_s4      <= addb[63:48];
            en_s4        <= en_s3;
            carry_in_s4  <= sum_stage3[16]; // carry out from stage 3
        end
    end

    assign sum_stage4 = adda_s4 + addb_s4 + carry_in_s4;

    // Final result register and output enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            result <= {sum_stage4[16], sum_stage4[15:0], sum_stage3[15:0], sum_stage2[15:0], sum_stage1[15:0]};
            o_en   <= en_s4;
        end
    end

endmodule