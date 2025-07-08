module multi_pipe_4bit #
(
    parameter size = 4
)
(
    input                      clk,
    input                      rst_n,
    input      [size-1:0]      mul_a,
    input      [size-1:0]      mul_b,
    output reg [2*size-1:0]    mul_out
);

    // Extended inputs: add size zeros to MSB side
    wire [2*size-1:0] extended_a = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] extended_b = { {size{1'b0}}, mul_b }; // not used directly, but per instructions

    // Partial products signals
    wire [2*size-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (extended_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // First pipeline stage registers: two registers to store sums of partial products
    reg [2*size-1:0] stage1;
    reg [2*size-1:0] stage2;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            stage1 <= 0;
            stage2 <= 0;
        end else begin
            stage1 <= partial_products[0] + partial_products[1];
            stage2 <= partial_products[2] + partial_products[3];
        end
    end

    // Second pipeline stage: add the two stage1 registers and output
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= stage1 + stage2;
        end
    end

endmodule