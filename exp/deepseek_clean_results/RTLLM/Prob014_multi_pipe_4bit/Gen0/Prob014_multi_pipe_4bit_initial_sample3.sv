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
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : pp_gen
            assign pp[i] = ext_b[i] ? (ext_a << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Pipeline stage 1 registers (sum of first 2 partial products)
    reg [2*size-1:0] sum_stage1;
    // Pipeline stage 2 registers (sum of next 2 partial products)
    reg [2*size-1:0] sum_stage2;

    // Pipeline stage 1: sum first two partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1 <= 0;
        end else begin
            sum_stage1 <= pp[0] + pp[1];
        end
    end

    // Pipeline stage 2: sum next two partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2 <= 0;
        end else begin
            sum_stage2 <= pp[2] + pp[3];
        end
    end

    // Final output stage: sum both pipeline stages
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= sum_stage1 + sum_stage2;
        end
    end

endmodule