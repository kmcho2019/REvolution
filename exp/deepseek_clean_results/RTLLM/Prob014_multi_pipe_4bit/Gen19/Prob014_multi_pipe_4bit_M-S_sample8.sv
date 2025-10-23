module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline stage 1 registers
reg [2*size-1:0] mul_a_ext;
reg [2*size-1:0] mul_b_ext;
reg [2*size-1:0] partial_products [0:size-1];

// Pipeline stage 2 registers
reg [2*size-1:0] sum_stage1;

// Generate partial products
integer i;
always @(*) begin
    for (i = 0; i < size; i = i + 1) begin
        partial_products[i] = mul_b_ext[i] ? (mul_a_ext << i) : 0;
    end
end

// Pipeline stage 1: Register inputs and generate partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_ext <= 0;
        mul_b_ext <= 0;
        sum_stage1 <= 0;
    end else begin
        // Extend inputs with zeros
        mul_a_ext <= {{size{1'b0}}, mul_a};
        mul_b_ext <= {{size{1'b0}}, mul_b};
        
        // Sum all partial products
        sum_stage1 <= partial_products[0] + partial_products[1] + 
                      partial_products[2] + partial_products[3];
    end
end

// Pipeline stage 2: Register final output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= sum_stage1;
    end
end

endmodule