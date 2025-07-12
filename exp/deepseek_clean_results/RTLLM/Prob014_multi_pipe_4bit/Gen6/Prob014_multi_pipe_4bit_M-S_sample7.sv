module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended multiplicand
    wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};
    
    // Partial products (unrolled since size=4)
    wire [2*size-1:0] pp0 = mul_b[0] ? a_ext : 0;
    wire [2*size-1:0] pp1 = mul_b[1] ? (a_ext << 1) : 0;
    wire [2*size-1:0] pp2 = mul_b[2] ? (a_ext << 2) : 0;
    wire [2*size-1:0] pp3 = mul_b[3] ? (a_ext << 3) : 0;

    // Pipeline registers
    reg [2*size-1:0] sum01_reg;
    reg [2*size-1:0] sum23_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum01_reg <= 0;
            sum23_reg <= 0;
            mul_out <= 0;
        end else begin
            // Stage 1: Sum pp0+pp1 and pp2+pp3
            sum01_reg <= pp0 + pp1;
            sum23_reg <= pp2 + pp3;
            
            // Stage 2: Final sum
            mul_out <= sum01_reg + sum23_reg;
        end
    end

endmodule