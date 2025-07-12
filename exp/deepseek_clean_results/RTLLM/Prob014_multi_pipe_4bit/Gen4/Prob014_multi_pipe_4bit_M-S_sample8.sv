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

    // Partial products
    wire [2*size-1:0] pp [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = ext_b[i] ? (ext_a << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Pipeline stage 1 registers
    reg [2*size-1:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;

    // Pipeline stage 2 signals
    wire [2*size-1:0] sum01 = pp0_reg + pp1_reg;
    wire [2*size-1:0] sum23 = pp2_reg + pp3_reg;
    reg [2*size-1:0] sum01_reg, sum23_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            pp0_reg <= {(2*size){1'b0}};
            pp1_reg <= {(2*size){1'b0}};
            pp2_reg <= {(2*size){1'b0}};
            pp3_reg <= {(2*size){1'b0}};
            sum01_reg <= {(2*size){1'b0}};
            sum23_reg <= {(2*size){1'b0}};
            mul_out <= {(2*size){1'b0}};
        end else begin
            // Pipeline stage 1: store all partial products
            pp0_reg <= pp[0];
            pp1_reg <= pp[1];
            pp2_reg <= pp[2];
            pp3_reg <= pp[3];

            // Pipeline stage 2: store intermediate sums
            sum01_reg <= sum01;
            sum23_reg <= sum23;

            // Final output
            mul_out <= sum01_reg + sum23_reg;
        end
    end

endmodule