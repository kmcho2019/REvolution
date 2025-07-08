module multi_pipe_4bit #(
    parameter size = 4
)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [size-1:0]      mul_a,
    input  wire [size-1:0]      mul_b,
    output reg  [(2*size)-1:0]  mul_out
);

    // Extend inputs by size zeros at MSB side
    wire [(2*size)-1:0] mul_a_ext = { {(size){1'b0}}, mul_a };
    wire [(2*size)-1:0] mul_b_ext = { {(size){1'b0}}, mul_b };

    // Partial products array
    wire [(2*size)-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = (mul_b[i]) ? (mul_a_ext << i) : { (2*size){1'b0} };
        end
    endgenerate

    // Pipeline stage registers to hold partial sums
    reg [(2*size)-1:0] stage1_sum;
    reg [(2*size)-1:0] stage2_sum;

    // Sum partial products in two pipeline stages:
    // Stage 1 sums partial_products[0] and partial_products[1]
    // Stage 2 sums partial_products[2] and partial_products[3]
    // Then final sum adds stage1_sum and stage2_sum in output register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum <= {(2*size){1'b0}};
            stage2_sum <= {(2*size){1'b0}};
            mul_out    <= {(2*size){1'b0}};
        end else begin
            stage1_sum <= partial_products[0] + partial_products[1];
            stage2_sum <= partial_products[2] + partial_products[3];
            mul_out    <= stage1_sum + stage2_sum;
        end
    end

endmodule