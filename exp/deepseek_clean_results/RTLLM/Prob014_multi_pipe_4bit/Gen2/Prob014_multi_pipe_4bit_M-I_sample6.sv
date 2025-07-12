module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended versions of inputs
    wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

    // Partial products (all calculated in parallel)
    wire [2*size-1:0] pp [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = ext_b[i] ? (ext_a << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Pipeline stage 1 calculations (parallel additions)
    wire [2*size-1:0] sum01 = pp[0] + pp[1];
    wire [2*size-1:0] sum23 = pp[2] + pp[3];
    
    // Pipeline stage 1 registers
    reg [2*size-1:0] sum01_reg;
    reg [2*size-1:0] sum23_reg;

    // Pipeline stage 2 calculation (final sum)
    wire [2*size-1:0] final_sum = sum01_reg + sum23_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            sum01_reg <= {(2*size){1'b0}};
            sum23_reg <= {(2*size){1'b0}};
            mul_out <= {(2*size){1'b0}};
        end else begin
            // Pipeline stage 1: store parallel sums
            sum01_reg <= sum01;
            sum23_reg <= sum23;

            // Final output: store sum of intermediate sums
            mul_out <= final_sum;
        end
    end

endmodule