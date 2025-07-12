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
    wire [2*size-1:0] pp [size-1:0];
    
    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = ext_b[i] ? (ext_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline registers
    reg [2*size-1:0] stage1_sum;
    reg [2*size-1:0] stage2_sum;

    // First pipeline stage: sum of first two partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum <= {2*size{1'b0}};
        end else begin
            stage1_sum <= pp[0] + pp[1];
        end
    end

    // Second pipeline stage: sum of next two partial products and previous sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= {2*size{1'b0}};
        end else begin
            stage2_sum <= stage1_sum + pp[2] + pp[3];
        end
    end

    // Output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= stage2_sum;
        end
    end

endmodule