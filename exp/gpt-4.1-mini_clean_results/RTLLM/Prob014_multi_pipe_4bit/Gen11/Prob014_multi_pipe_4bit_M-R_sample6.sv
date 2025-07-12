module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by 'size' zero bits on MSB side (combinational)
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Stage 1 registers: registered inputs and sum of partial products bits 0 and 1
    reg [2*size-1:0] stage1_mul_a;
    reg [size-1:0]   stage1_mul_b;
    reg [2*size-1:0] stage1_sum;

    // Combinational partial products for bits 0 and 1 (based on registered stage1 multiplier and multiplicand)
    wire [2*size-1:0] pp0 = stage1_mul_b[0] ? (stage1_mul_a << 0) : {2*size{1'b0}};
    wire [2*size-1:0] pp1 = stage1_mul_b[1] ? (stage1_mul_a << 1) : {2*size{1'b0}};
    wire [2*size-1:0] sum01 = pp0 + pp1;

    // Stage 2 combinational partial products for bits 2 and 3
    wire [2*size-1:0] pp2 = stage1_mul_b[2] ? (stage1_mul_a << 2) : {2*size{1'b0}};
    wire [2*size-1:0] pp3 = stage1_mul_b[3] ? (stage1_mul_a << 3) : {2*size{1'b0}};
    wire [2*size-1:0] sum23 = pp2 + pp3;

    // Stage 1: Register inputs and sum of bits 0 and 1 partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_mul_a <= {2*size{1'b0}};
            stage1_mul_b <= {size{1'b0}};
            stage1_sum   <= {2*size{1'b0}};
        end else begin
            stage1_mul_a <= ext_mul_a;
            stage1_mul_b <= mul_b;
            stage1_sum   <= sum01;
        end
    end

    // Stage 2: Register final product sum of previous sum plus partial products bits 2 and 3
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= stage1_sum + sum23;
        end
    end

endmodule