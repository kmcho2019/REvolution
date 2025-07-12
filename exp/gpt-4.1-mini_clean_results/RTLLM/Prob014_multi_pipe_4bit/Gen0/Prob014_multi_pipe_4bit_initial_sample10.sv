module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input   [size-1:0]      mul_a,
    input   [size-1:0]      mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended multiplicand and multiplier with zeros at MSB side (doubled width)
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] ext_mul_b = { {size{1'b0}}, mul_b };

    // Partial products array
    wire [2*size-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = (mul_b[i]) ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Two pipeline registers for storing intermediate sums
    reg [2*size-1:0] pipeline_reg1;
    reg [2*size-1:0] pipeline_reg2;

    // On each clk posedge or rst_n negedge perform pipeline and reset
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            pipeline_reg1 <= {2*size{1'b0}};
            pipeline_reg2 <= {2*size{1'b0}};
            mul_out       <= {2*size{1'b0}};
        end
        else begin
            // First pipeline stage: sum first half partial products
            pipeline_reg1 <= partial_products[0] + partial_products[1];
            // Second pipeline stage: sum next half partial products plus pipeline_reg1
            pipeline_reg2 <= partial_products[2] + partial_products[3] + pipeline_reg1;
            // Output the final product
            mul_out       <= pipeline_reg2;
        end
    end

endmodule