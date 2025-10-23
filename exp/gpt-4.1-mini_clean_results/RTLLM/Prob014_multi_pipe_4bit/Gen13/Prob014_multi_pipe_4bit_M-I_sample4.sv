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
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j=0; j<size; j=j+1)
                stage1_partial_products[j] <= {2*size{1'b0}};
        end else begin
            for (j=0; j<size; j=j+1)
                stage1_partial_products[j] <= partial_products[j];
        end
    end

    // --- Stage 2: sequentially accumulate partial products over multiple clock cycles ---
    reg [1:0] add_index;  // counts from 0 to size-1 (0 to 3)
    reg [2*size-1:0] accumulator;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            add_index <= 0;
            accumulator <= {2*size{1'b0}};
            mul_out <= {2*size{1'b0}};
        end else begin
            if (add_index == 0) begin
                // Start new accumulation with first partial product
                accumulator <= stage1_partial_products[0];
                add_index <= 1;
                mul_out <= {2*size{1'b0}}; // Output valid only after all sums
            end else if (add_index < size) begin
                accumulator <= accumulator + stage1_partial_products[add_index];
                add_index <= add_index + 1;
                mul_out <= {2*size{1'b0}}; // Output not valid yet
            end else begin
                // All partial products accumulated, output final product
                mul_out <= accumulator;
                add_index <= 0; // Ready for next multiplication inputs
            end
        end
    end

endmodule