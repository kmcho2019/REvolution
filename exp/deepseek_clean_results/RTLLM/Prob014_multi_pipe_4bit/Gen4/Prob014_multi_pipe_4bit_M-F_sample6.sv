module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

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

    // Pipeline registers
    reg [2*size-1:0] stage1_sum;  // sum of pp[0] and pp[1]
    reg [2*size-1:0] stage1_pp2;  // registered pp[2]
    reg [2*size-1:0] stage1_pp3;  // registered pp[3]
    reg [2*size-1:0] stage2_sum;  // intermediate sum

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // First stage reset
            stage1_sum <= 0;
            stage1_pp2 <= 0;
            stage1_pp3 <= 0;
            
            // Second stage reset
            stage2_sum <= 0;
            mul_out <= 0;
        end else begin
            // First pipeline stage: sum pp[0] + pp[1] and register pp[2], pp[3]
            stage1_sum <= pp[0] + pp[1];
            stage1_pp2 <= pp[2];
            stage1_pp3 <= pp[3];
            
            // Second pipeline stage: sum intermediate values
            stage2_sum <= stage1_sum + stage1_pp2;
            mul_out <= stage2_sum + stage1_pp3;
        end
    end

endmodule