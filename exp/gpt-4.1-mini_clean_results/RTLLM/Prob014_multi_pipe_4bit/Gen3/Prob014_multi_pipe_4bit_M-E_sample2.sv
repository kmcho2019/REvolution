module multi_pipe_4bit #(
    parameter size = 4
)(
    input                      clk,
    input                      rst_n,      // active low synchronous reset
    input      [size-1:0]      mul_a,
    input      [size-1:0]      mul_b,
    output reg [2*size-1:0]    mul_out
);

    // Extended multiplicand: size zeros at MSB, then mul_a
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };

    // Generate partial products for each bit of mul_b
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 registers: latch all partial products
    reg [2*size-1:0] pp_reg [0:size-1];

    integer j;
    always @(posedge clk) begin
        if (~rst_n) begin
            for (j=0; j<size; j=j+1)
                pp_reg[j] <= {2*size{1'b0}};
        end else begin
            for (j=0; j<size; j=j+1)
                pp_reg[j] <= partial_products[j];
        end
    end

    // Stage 2: sum partial products using binary tree adder with registers between stages
    // First level sums: sum pairs pp_reg[0]+pp_reg[1], pp_reg[2]+pp_reg[3]
    reg [2*size-1:0] sum_level1 [0:(size/2)-1];
    always @(posedge clk) begin
        if (~rst_n) begin
            for (j=0; j<(size/2); j=j+1)
                sum_level1[j] <= {2*size{1'b0}};
        end else begin
            sum_level1[0] <= pp_reg[0] + pp_reg[1];
            sum_level1[1] <= pp_reg[2] + pp_reg[3];
        end
    end

    // Final sum stage: sum sum_level1[0] + sum_level1[1]
    reg [2*size-1:0] sum_level2;
    always @(posedge clk) begin
        if (~rst_n) begin
            sum_level2 <= {2*size{1'b0}};
            mul_out <= {2*size{1'b0}};
        end else begin
            sum_level2 <= sum_level1[0] + sum_level1[1];
            mul_out <= sum_level2;
        end
    end

endmodule