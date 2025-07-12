module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand and multiplier to 2*size bits by padding MSBs with zeros
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] ext_mul_b = {{size{1'b0}}, mul_b};

    // --- Generate partial products combinationally ---
    // Each partial product is ext_mul_a ANDed bitwise with one multiplier bit, shifted by bit index
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : GEN_PARTIALS
            // Replicate mul_b[i] across 2*size bits and AND with ext_mul_a shifted i bits left
            wire bit_b = mul_b[i];
            wire [2*size-1:0] shifted_a = ext_mul_a << i;
            assign partial_products[i] = bit_b ? shifted_a : {2*size{1'b0}};
        end
    endgenerate

    // --- Stage 1 registers: latch partial products ---
    reg [2*size-1:0] stage1_partial_products [0:size-1];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<size; i=i+1)
                stage1_partial_products[i] <= 0;
        end else begin
            for (i=0; i<size; i=i+1)
                stage1_partial_products[i] <= partial_products[i];
        end
    end

    // --- Stage 2: accumulate partial products sequentially over multiple clock cycles ---
    reg [1:0] add_index;  // counts from 0 to size-1 (0 to 3)
    reg [2*size-1:0] accumulator;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            add_index <= 0;
            accumulator <= 0;
            mul_out <= 0;
        end else begin
            // On first cycle after stage1 registers updated, reset accumulator and add_index
            if(add_index == 0) begin
                accumulator <= stage1_partial_products[0];
                add_index <= 1;
                mul_out <= 0; // output will be ready after full accumulation
            end else if(add_index < size) begin
                accumulator <= accumulator + stage1_partial_products[add_index];
                add_index <= add_index + 1;
                mul_out <= 0;
            end else begin
                // When done accumulating all partials, output the product
                mul_out <= accumulator;
                // Wait for next multiplication inputs by resetting index for next multiplication
                add_index <= 0;
            end
        end
    end

endmodule