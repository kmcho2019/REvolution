module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Input extension with parameterized width
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

// Stage 1: Partial Product Generation (Combinational)
wire [2*size-1:0] partial_products [0:size-1];

genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin : PARTIAL_GEN
        assign partial_products[i] = ext_b[i] ? (ext_a << i) : {(2*size){1'b0}};
    end
endgenerate

// Pipeline Register between Stage 1 and Stage 2
reg [2*size-1:0] pp_reg [0:size-1];

// Stage 2: Accumulation (Registered)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear pipeline registers
        for (integer j = 0; j < size; j = j + 1) begin
            pp_reg[j] <= {(2*size){1'b0}};
        end
        mul_out <= {(2*size){1'b0}};
    end else begin
        // Register partial products
        for (integer j = 0; j < size; j = j + 1) begin
            pp_reg[j] <= partial_products[j];
        end
        
        // Accumulate results (adder tree)
        mul_out <= (pp_reg[0] + pp_reg[1]) + (pp_reg[2] + pp_reg[3]);
    end
end

endmodule