module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Zero-extended inputs as per requirements
    wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

    // Input registers
    reg [2*size-1:0] ext_a_reg, ext_b_reg;

    // Partial products generation
    wire [2*size-1:0] pp [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = ext_b_reg[i] ? (ext_a_reg << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Pipeline Stage 1: First level of addition
    wire [2*size-1:0] sum0 = pp[0] + pp[1];
    wire [2*size-1:0] sum1 = pp[2] + pp[3];
    reg [2*size-1:0] sum0_reg, sum1_reg;

    // Pipeline Stage 2: Final addition
    wire [2*size-1:0] final_sum = sum0_reg + sum1_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ext_a_reg <= {(2*size){1'b0}};
            ext_b_reg <= {(2*size){1'b0}};
            sum0_reg <= {(2*size){1'b0}};
            sum1_reg <= {(2*size){1'b0}};
            mul_out <= {(2*size){1'b0}};
        end else begin
            // Stage 1 registers
            ext_a_reg <= ext_a;
            ext_b_reg <= ext_b;
            
            // Stage 2 registers
            sum0_reg <= sum0;
            sum1_reg <= sum1;
            
            // Output (registered after 2 stages)
            mul_out <= final_sum;
        end
    end

endmodule