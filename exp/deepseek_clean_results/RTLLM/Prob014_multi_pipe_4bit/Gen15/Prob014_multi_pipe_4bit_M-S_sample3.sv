module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extended inputs with size zeros at MSB
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};

// Pipeline stage 1: Partial product generation
reg [2*size-1:0] partial_products [0:size-1];
reg [size-1:0] b_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (integer i = 0; i < size; i = i + 1)
            partial_products[i] <= '0;
        b_reg <= '0;
    end else begin
        b_reg <= mul_b;
        for (integer i = 0; i < size; i = i + 1)
            partial_products[i] <= mul_b[i] ? (ext_a << i) : '0;
    end
end

// Pipeline stage 2: Accumulation
reg [2*size-1:0] accumulator;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accumulator <= '0;
        mul_out <= '0;
    end else begin
        // Reset accumulator for new calculation
        if (b_reg != mul_b) begin
            accumulator <= '0;
        end
        
        // Accumulate partial products
        accumulator <= partial_products[0] + partial_products[1] + 
                      partial_products[2] + partial_products[3];
        
        // Register final output
        mul_out <= accumulator;
    end
end

endmodule