module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Clock enable when inputs are non-zero
    wire clk_en = |mul_a || |mul_b;

    // Extended inputs with zeros at MSB
    wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] b_ext = {{size{1'b0}}, mul_b};

    // Packed array for partial products
    reg [2*size-1:0] pp [0:size-1];

    // Generate partial products
    integer i;
    always @(*) begin
        for (i = 0; i < size; i = i + 1) begin
            pp[i] = b_ext[i] ? (a_ext << i) : {(2*size){1'b0}};
        end
    end

    // Pipeline registers with clock gating
    reg [2*size-1:0] stage1_sum;  // sum of pp[0] and pp[1]
    reg [2*size-1:0] stage1_pp2;  // registered pp[2]
    reg [2*size-1:0] stage1_pp3;  // registered pp[3]

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum <= 0;
            stage1_pp2 <= 0;
            stage1_pp3 <= 0;
            mul_out <= 0;
        end else if (clk_en) begin
            // First pipeline stage: register partial products
            stage1_sum <= pp[0] + pp[1];
            stage1_pp2 <= pp[2];
            stage1_pp3 <= pp[3];
            
            // Second pipeline stage: final sum
            mul_out <= stage1_sum + stage1_pp2 + stage1_pp3;
        end
    end

endmodule