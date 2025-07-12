module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended multiplicand with size zeros at MSB
    wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};

    // Partial products (combinational)
    wire [2*size-1:0] pp [size-1:0];
    generate
        genvar i;
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b[i] ? (ext_a << i) : 0;
        end
    endgenerate

    // Pipeline stage 1: Register partial products
    reg [2*size-1:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0_reg <= 0;
            pp1_reg <= 0;
            pp2_reg <= 0;
            pp3_reg <= 0;
        end else begin
            pp0_reg <= pp[0];
            pp1_reg <= pp[1];
            pp2_reg <= pp[2];
            pp3_reg <= pp[3];
        end
    end

    // Pipeline stage 2: First level additions
    wire [2*size-1:0] sum0 = pp0_reg + pp1_reg;
    wire [2*size-1:0] sum1 = pp2_reg + pp3_reg;
    reg [2*size-1:0] sum0_reg, sum1_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0_reg <= 0;
            sum1_reg <= 0;
        end else begin
            sum0_reg <= sum0;
            sum1_reg <= sum1;
        end
    end

    // Pipeline stage 3: Final addition
    reg [2*size-1:0] final_sum_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_sum_reg <= 0;
            mul_out <= 0;
        end else begin
            final_sum_reg <= sum0_reg + sum1_reg;
            mul_out <= final_sum_reg;
        end
    end

endmodule