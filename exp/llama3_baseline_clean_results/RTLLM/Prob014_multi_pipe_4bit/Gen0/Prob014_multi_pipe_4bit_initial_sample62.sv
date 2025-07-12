module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

// Extension of input signals by adding leading zeros
wire [2*size-1:0] extended_mul_a = { {size{1'b0}}, mul_a };
wire [2*size-1:0] extended_mul_b = { {size{1'b0}}, mul_b };

// Generate block to calculate partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        wire [2*size-1:0] partial_product;
        if (i == 0) begin
            assign partial_product = (mul_b[i] == 1'b1) ? extended_mul_a : {2*size{1'b0}};
        end else begin
            wire [2*size-1:0] shifted_mul_a = extended_mul_a << i;
            assign partial_product = (mul_b[i] == 1'b1) ? shifted_mul_a : {2*size{1'b0}};
        end
    end
endgenerate

// Add partial products using registers to store intermediate sum values
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg1 <= {2*size{1'b0}};
        reg2 <= {2*size{1'b0}};
    end else begin
        reg1 <= { {size{1'b0}}, mul_a } + (mul_b[0] == 1'b1) ? { {size{1'b0}}, mul_a } : {2*size{1'b0}};
        for (genvar i = 1; i < size; i++) begin
            wire [2*size-1:0] partial_product;
            wire [2*size-1:0] shifted_mul_a = extended_mul_a << i;
            assign partial_product = (mul_b[i] == 1'b1) ? shifted_mul_a : {2*size{1'b0}};
            if (i == 1) begin
                reg2 <= reg1 + partial_product;
            end else begin
                reg2 <= reg2 + partial_product;
            end
        end
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= reg2;
    end
end

endmodule