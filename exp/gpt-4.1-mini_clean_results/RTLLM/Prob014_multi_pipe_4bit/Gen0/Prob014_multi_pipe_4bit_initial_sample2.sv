module multi_pipe_4bit #(parameter size = 4)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [size-1:0]      mul_a,
    input  wire [size-1:0]      mul_b,
    output reg  [2*size-1:0]    mul_out
);

    // Extend inputs by size zeros at MSB side
    wire [2*size-1:0] a_ext = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] b_ext = { {size{1'b0}}, mul_b };

    // Partial products generated for each bit of multiplier
    wire [2*size-1:0] partial [0:size-1];
    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : GEN_PARTIALS
            assign partial[i] = b_ext[i] ? (a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline registers for two levels of accumulation
    // Stage 1: sum partial[0..1] into reg_stage1[0], partial[2..3] into reg_stage1[1]
    reg [2*size-1:0] reg_stage1 [0:1];
    // Stage 2: sum of reg_stage1[0] + reg_stage1[1] in reg_stage2
    reg [2*size-1:0] reg_stage2;

    // First pipeline stage: accumulate partial products in pairs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_stage1[0] <= 0;
            reg_stage1[1] <= 0;
        end else begin
            reg_stage1[0] <= partial[0] + partial[1];
            reg_stage1[1] <= partial[2] + partial[3];
        end
    end

    // Second pipeline stage: accumulate results from first stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_stage2 <= 0;
        end else begin
            reg_stage2 <= reg_stage1[0] + reg_stage1[1];
        end
    end

    // Final output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= reg_stage2;
        end
    end

endmodule