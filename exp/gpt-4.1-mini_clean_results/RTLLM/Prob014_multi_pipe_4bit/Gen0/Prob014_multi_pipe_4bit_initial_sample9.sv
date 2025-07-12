module multi_pipe_4bit #(
    parameter size = 4
)(
    input                    clk,
    input                    rst_n,
    input      [size-1:0]    mul_a,
    input      [size-1:0]    mul_b,
    output reg [(2*size)-1:0] mul_out
);

    // Extend inputs by adding 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] ext_mul_b = { {size{1'b0}}, mul_b };  // Though not used directly in multiplication, for uniformity.

    // Generate partial products for bits [0 to size-1] of mul_b
    wire [2*size-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Divide partial products into two groups for 2-level pipeline
    // Level 1 register sums partial_products[0 to size/2 - 1]
    // Level 2 register sums partial_products[size/2 to size-1]
    localparam half = size/2;

    reg [2*size-1:0] reg_level1, reg_level2;

    integer j;

    // Combinational sums for partial products groups
    wire [2*size-1:0] sum_level1;
    wire [2*size-1:0] sum_level2;

    // Sum partial products [0..half-1]
    reg [2*size-1:0] tmp_sum_level1;
    // Sum partial products [half..size-1]
    reg [2*size-1:0] tmp_sum_level2;

    always @(*) begin
        tmp_sum_level1 = {2*size{1'b0}};
        tmp_sum_level2 = {2*size{1'b0}};
        for (j=0; j<half; j=j+1) begin
            tmp_sum_level1 = tmp_sum_level1 + partial_products[j];
        end
        for (j=half; j<size; j=j+1) begin
            tmp_sum_level2 = tmp_sum_level2 + partial_products[j];
        end
    end

    assign sum_level1 = tmp_sum_level1;
    assign sum_level2 = tmp_sum_level2;

    // Register update and final output calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_level1 <= {2*size{1'b0}};
            reg_level2 <= {2*size{1'b0}};
            mul_out    <= {(2*size){1'b0}};
        end else begin
            reg_level1 <= sum_level1;
            reg_level2 <= sum_level2;
            mul_out    <= reg_level1 + reg_level2;
        end
    end

endmodule