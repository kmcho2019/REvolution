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

    // Split partial products into two halves for pipeline stages
    localparam half = size / 2;

    // Function to perform balanced sum of an array of vectors
    // Using recursive reduction of addition with generate blocks
    // Implemented here as a function for clarity
    function [2*size-1:0] sum_array;
        input integer count;
        input [2*size-1:0] data [0:size-1];
        integer idx;
        reg [2*size-1:0] temp [0:size-1];
        integer num_elements, i, j;
        begin
            // Copy input to temp
            for (idx = 0; idx < count; idx = idx +1) begin
                temp[idx] = data[idx];
            end
            num_elements = count;

            // Iteratively reduce the array size by pairwise addition
            while (num_elements > 1) begin
                for (i = 0, j = 0; i < num_elements; i = i + 2, j = j + 1) begin
                    if (i + 1 < num_elements)
                        temp[j] = temp[i] + temp[i + 1];
                    else
                        temp[j] = temp[i];
                end
                num_elements = (num_elements + 1) >> 1; // Divide by 2 rounded up
            end
            sum_array = temp[0];
        end
    endfunction

    // Wires for combinational sums of each half
    wire [2*size-1:0] sum_first_half;
    wire [2*size-1:0] sum_second_half;

    // Prepare arrays for first and second half partial products
    wire [2*size-1:0] first_half_array [0:half-1];
    wire [2*size-1:0] second_half_array [0:(size - half) - 1];

    generate
        for (i = 0; i < half; i = i + 1) begin
            assign first_half_array[i] = partial_products[i];
        end
        for (i = 0; i < (size - half); i = i + 1) begin
            assign second_half_array[i] = partial_products[half + i];
        end
    endgenerate

    // Assign sums by calling sum_array function
    assign sum_first_half  = sum_array(half, first_half_array);
    assign sum_second_half = sum_array(size - half, second_half_array);

    // Pipeline registers for intermediate sums
    reg [2*size-1:0] sum_stage1_reg;
    reg [2*size-1:0] sum_stage2_reg;

    // Stage 1 registers: latch sums of partial products halves
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1_reg <= {2*size{1'b0}};
            sum_stage2_reg <= {2*size{1'b0}};
        end else begin
            sum_stage1_reg <= sum_first_half;
            sum_stage2_reg <= sum_second_half;
        end
    end

    // Stage 2 register: final sum of stage 1 pipeline registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= sum_stage1_reg + sum_stage2_reg;
        end
    end

endmodule