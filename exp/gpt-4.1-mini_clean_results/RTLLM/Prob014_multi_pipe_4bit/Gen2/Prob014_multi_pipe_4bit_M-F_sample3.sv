module multi_pipe_4bit #(parameter size = 4)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [size-1:0]      mul_a,
    input  wire [size-1:0]      mul_b,
    output reg  [2*size-1:0]    mul_out
);

    // Extend multiplicand by size zeros at MSB to get 2*size bits width
    wire [2*size-1:0] a_ext = { {size{1'b0}}, mul_a };

    // Partial products array
    wire [2*size-1:0] partial [0:size-1];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial[i] = mul_b[i] ? (a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline registers for stage 1 sums (two registers)
    reg [2*size-1:0] reg_stage1 [0:1];
    // Pipeline register for stage 2 sum (final partial sum)
    reg [2*size-1:0] reg_stage2;

    // Stage 1: sum partial products in pairs (0+1) and (2+3)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_stage1[0] <= {2*size{1'b0}};
            reg_stage1[1] <= {2*size{1'b0}};
        end else begin
            reg_stage1[0] <= partial[0] + partial[1];
            reg_stage1[1] <= partial[2] + partial[3];
        end
    end

    // Stage 2: sum outputs from stage 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_stage2 <= {2*size{1'b0}};
        end else begin
            reg_stage2 <= reg_stage1[0] + reg_stage1[1];
        end
    end

    // Output register for final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= reg_stage2;
        end
    end

endmodule