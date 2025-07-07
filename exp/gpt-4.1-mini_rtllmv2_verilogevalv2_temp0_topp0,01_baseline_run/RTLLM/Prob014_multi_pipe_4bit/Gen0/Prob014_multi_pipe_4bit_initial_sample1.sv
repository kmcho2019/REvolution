module multi_pipe_4bit #(
    parameter size = 4
)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [size-1:0]      mul_a,
    input  wire [size-1:0]      mul_b,
    output reg  [(2*size)-1:0]  mul_out
);

    // Extend inputs by size zeros at MSB side
    wire [(2*size)-1:0] mul_a_ext = { {size{1'b0}}, mul_a };
    wire [(2*size)-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : { (2*size){1'b0} };
        end
    endgenerate

    // Two levels of registers to store intermediate sums
    reg [(2*size)-1:0] stage1_reg0, stage1_reg1;
    reg [(2*size)-1:0] stage2_reg0, stage2_reg1;

    // First pipeline stage: sum partial_products[0] and partial_products[1]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_reg0 <= 0;
            stage1_reg1 <= 0;
        end else begin
            stage1_reg0 <= partial_products[0];
            stage1_reg1 <= partial_products[1];
        end
    end

    // Second pipeline stage: sum partial_products[2] and partial_products[3]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_reg0 <= 0;
            stage2_reg1 <= 0;
        end else begin
            stage2_reg0 <= partial_products[2];
            stage2_reg1 <= partial_products[3];
        end
    end

    // Final product calculation: sum of stage1 and stage2 registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= (stage1_reg0 + stage1_reg1) + (stage2_reg0 + stage2_reg1);
        end
    end

endmodule