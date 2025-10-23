module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Extended input signals
wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };
wire [2*size-1:0] ext_mul_b = { {size{1'b0}}, mul_b };

// Registers for intermediate sum values
reg [2*size-1:0] sum_reg1;
reg [2*size-1:0] sum_reg2;

// Generate block for partial product calculation
genvar i;
generate
    for (i = 0; i < size; i++) begin
        wire [2*size-1:0] partial_product;
        assign partial_product = (ext_mul_b[i] == 1'b1) ? (ext_mul_a << i) : {2*size{1'b0}};
        
        // First level of registers
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                sum_reg1 <= {2*size{1'b0}};
            end else if (i == 0) begin
                sum_reg1 <= partial_product;
            end else begin
                sum_reg1 <= sum_reg1 + partial_product;
            end
        end
        
        // Second level of registers
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                sum_reg2 <= {2*size{1'b0}};
            end else if (i == size-1) begin
                sum_reg2 <= sum_reg1;
            end else begin
                sum_reg2 <= sum_reg2;
            end
        end
    end
endgenerate

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= sum_reg2;
    end
end

endmodule