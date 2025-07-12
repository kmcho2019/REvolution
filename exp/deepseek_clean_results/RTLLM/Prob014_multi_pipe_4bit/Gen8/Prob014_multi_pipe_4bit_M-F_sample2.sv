module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Internal signals declaration
wire [2*size-1:0] pp [0:size-1];  // Partial products
reg [2*size-1:0] pp_reg [0:size-1]; // Pipeline stage 1 registers
reg [2*size-1:0] sum_reg;          // Pipeline stage 2 register

// Partial product generation
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin : pp_gen
        assign pp[i] = mul_b[i] ? {{(size){1'b0}}, mul_a} << i : {(2*size){1'b0}};
    end
endgenerate

// Pipeline stage 1: Register partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (integer j = 0; j < size; j = j + 1) begin
            pp_reg[j] <= {(2*size){1'b0}};
        end
    end else begin
        pp_reg <= pp;  // Array assignment
    end
end

// Pipeline stage 2: Sum using balanced adder tree
wire [2*size-1:0] sum_intermediate [0:size-1];

generate
    // First level of adders
    assign sum_intermediate[0] = pp_reg[0] + pp_reg[1];
    assign sum_intermediate[1] = pp_reg[2] + pp_reg[3];
    
    // Additional levels for larger sizes
    if (size > 4) begin
        for (i = 2; i < size/2; i = i + 1) begin
            assign sum_intermediate[i] = pp_reg[2*i] + pp_reg[2*i+1];
        end
    end
    
    // Final sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= {(2*size){1'b0}};
            mul_out <= {(2*size){1'b0}};
        end else begin
            if (size <= 4) begin
                sum_reg <= sum_intermediate[0] + sum_intermediate[1];
            end else begin
                // For larger sizes, continue the adder tree
                sum_reg <= sum_intermediate[0];
                for (i = 1; i < size/2; i = i + 1) begin
                    sum_reg <= sum_reg + sum_intermediate[i];
                end
            end
            mul_out <= sum_reg;
        end
    end
endgenerate

endmodule