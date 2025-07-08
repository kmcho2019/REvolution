module multi_pipe_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        mul_en_in,
    input  wire [7:0]  mul_a,
    input  wire [7:0]  mul_b,
    output wire        mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers for enable signal (8 stages total for pipeline latency)
    reg [7:0] mul_en_out_reg;

    // Input registers for operands
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires: each is 16 bits, partial product shifted by bit index
    wire [15:0] temp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign temp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Pipeline registers for partial sums
    // We'll perform the summation in stages to pipeline additions:
    // Stage 1: sum0 = temp[0] + temp[1]
    // Stage 2: sum1 = temp[2] + temp[3]
    // Stage 3: sum2 = temp[4] + temp[5]
    // Stage 4: sum3 = temp[6] + temp[7]
    // Stage 5: sum01 = sum0 + sum1
    // Stage 6: sum23 = sum2 + sum3
    // Stage 7: mul_out_reg = sum01 + sum23

    // Stage 1 registers
    reg [15:0] sum0_reg, sum1_reg, sum2_reg, sum3_reg;
    // Stage 2 registers
    reg [15:0] sum01_reg, sum23_reg;
    // Stage 3 register: final product
    reg [15:0] mul_out_reg;

    // Pipeline stage 1: latch inputs and enable signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out_reg <= 8'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else begin
            mul_en_out_reg <= {mul_en_out_reg[6:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 2: sum pairs of partial products (temp arrays)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0_reg <= 16'd0;
            sum1_reg <= 16'd0;
            sum2_reg <= 16'd0;
            sum3_reg <= 16'd0;
        end else begin
            sum0_reg <= temp[0] + temp[1];
            sum1_reg <= temp[2] + temp[3];
            sum2_reg <= temp[4] + temp[5];
            sum3_reg <= temp[6] + temp[7];
        end
    end

    // Stage 3: sum sums of stage 2
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum01_reg <= 16'd0;
            sum23_reg <= 16'd0;
        end else begin
            sum01_reg <= sum0_reg + sum1_reg;
            sum23_reg <= sum2_reg + sum3_reg;
        end
    end

    // Stage 4: final sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else begin
            mul_out_reg <= sum01_reg + sum23_reg;
        end
    end

    // Output enable is the MSB of the 8-bit shift register
    assign mul_en_out = mul_en_out_reg[7];

    // Output product is valid only when mul_en_out is high, else zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule