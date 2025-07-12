module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended inputs with size zeros at MSB
    wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

    // Partial products
    wire [2*size-1:0] pp [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = ext_b[i] ? (ext_a << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Pipeline stage 1 registers (sum of pp[0] and pp[1])
    reg [2*size-1:0] stage1_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_reg <= 0;
        end else begin
            stage1_reg <= pp[0] + pp[1];
        end
    end

    // Pipeline stage 2 registers (sum of pp[2] and pp[3])
    reg [2*size-1:0] stage2_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_reg <= 0;
        end else begin
            stage2_reg <= pp[2] + pp[3];
        end
    end

    // Final output stage (sum of both pipeline stages)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= stage1_reg + stage2_reg;
        end
    end

endmodule