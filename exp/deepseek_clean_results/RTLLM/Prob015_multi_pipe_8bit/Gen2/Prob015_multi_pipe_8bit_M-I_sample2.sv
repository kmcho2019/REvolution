module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline stage 1 registers (input)
    reg stage1_en;
    reg [7:0] stage1_a, stage1_b;
    
    // Pipeline stage 2 registers (partial products)
    reg stage2_en;
    reg [15:0] pp [7:0];
    
    // Pipeline stage 3 registers (accumulation)
    reg stage3_en;
    reg [15:0] stage3_product;

    // Generate all partial products (combinational)
    wire [15:0] pp_wire [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp_wire[i] = stage1_b[i] ? (stage1_a << i) : 16'b0;
        end
    endgenerate

    // Pipeline stage 1: Input sampling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_en <= 1'b0;
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
        end else begin
            stage1_en <= mul_en_in;
            if (mul_en_in) begin
                stage1_a <= mul_a;
                stage1_b <= mul_b;
            end
        end
    end

    // Pipeline stage 2: Partial product registration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_en <= 1'b0;
            for (integer j = 0; j < 8; j = j + 1) begin
                pp[j] <= 16'b0;
            end
        end else begin
            stage2_en <= stage1_en;
            if (stage1_en) begin
                for (integer j = 0; j < 8; j = j + 1) begin
                    pp[j] <= pp_wire[j];
                end
            end
        end
    end

    // Pipeline stage 3: Accumulation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage3_en <= 1'b0;
            stage3_product <= 16'b0;
        end else begin
            stage3_en <= stage2_en;
            if (stage2_en) begin
                stage3_product <= pp[0] + pp[1] + pp[2] + pp[3] + 
                                 pp[4] + pp[5] + pp[6] + pp[7];
            end
        end
    end

    // Output assignments
    assign mul_en_out = stage3_en;
    assign mul_out = stage3_product;

endmodule