module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend inputs by adding 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };

    // Generate partial products for each bit of mul_b
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Split partial products into two halves
    localparam half = size / 2;

    // Combinational summation of first half partial products
    // sum_first_half = partial_products[0] + partial_products[1] + ... partial_products[half-1]
    wire [2*size-1:0] sum_first_half;
    generate
        if (half == 1) begin
            // Only one partial product in first half
            assign sum_first_half = partial_products[0];
        end else if (half == 2) begin
            assign sum_first_half = partial_products[0] + partial_products[1];
        end else if (half == 3) begin
            wire [2*size-1:0] temp_sum;
            assign temp_sum = partial_products[0] + partial_products[1];
            assign sum_first_half = temp_sum + partial_products[2];
        end else if (half == 4) begin
            wire [2*size-1:0] sum0_1, sum2_3;
            assign sum0_1 = partial_products[0] + partial_products[1];
            assign sum2_3 = partial_products[2] + partial_products[3];
            assign sum_first_half = sum0_1 + sum2_3;
        end else begin
            // Default fallback: sum zero
            assign sum_first_half = {2*size{1'b0}};
        end
    endgenerate

    // Combinational summation of second half partial products
    // sum_second_half = partial_products[half] + ... partial_products[size-1]
    wire [2*size-1:0] sum_second_half;
    generate
        if ((size - half) == 1) begin
            assign sum_second_half = partial_products[half];
        end else if ((size - half) == 2) begin
            assign sum_second_half = partial_products[half] + partial_products[half+1];
        end else if ((size - half) == 3) begin
            wire [2*size-1:0] temp_sum2;
            assign temp_sum2 = partial_products[half] + partial_products[half+1];
            assign sum_second_half = temp_sum2 + partial_products[half+2];
        end else if ((size - half) == 4) begin
            wire [2*size-1:0] sum0_1_2, sum3;
            wire [2*size-1:0] sum01, sum23;
            assign sum01 = partial_products[half] + partial_products[half+1];
            assign sum23 = partial_products[half+2] + partial_products[half+3];
            assign sum_second_half = sum01 + sum23;
        end else if ((size - half) == 0) begin
            assign sum_second_half = {2*size{1'b0}};
        end else begin
            // Default fallback: zero sum
            assign sum_second_half = {2*size{1'b0}};
        end
    endgenerate

    // Pipeline registers for intermediate sums (stage 1)
    reg [2*size-1:0] sum_first_half_reg;
    reg [2*size-1:0] sum_second_half_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_first_half_reg  <= {2*size{1'b0}};
            sum_second_half_reg <= {2*size{1'b0}};
        end else begin
            sum_first_half_reg  <= sum_first_half;
            sum_second_half_reg <= sum_second_half;
        end
    end

    // Final pipeline stage: sum of stage 1 registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= sum_first_half_reg + sum_second_half_reg;
        end
    end

endmodule