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
reg [2*size-1:0] extended_mul_a;
reg [size-1:0] extended_mul_b;

// Intermediate registers
reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

// Partial products
reg [2*size-1:0] partial_product [size-1:0];

// Final product calculation
reg [2*size-1:0] final_product;

// Generate block to calculate partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        always @(*) begin
            if (mul_b[i]) begin
                partial_product[i] = {mul_a, {size{1'b0}}} << i;
            end else begin
                partial_product[i] = {2*size{1'b0}};
            end
        end
    end
endgenerate

// Update extended input signals
always @(*) begin
    extended_mul_a = {mul_a, {size{1'b0}}};
    extended_mul_b = mul_b;
end

// Update intermediate registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg1 <= {2*size{1'b0}};
        reg2 <= {2*size{1'b0}};
    end else begin
        reg1 <= partial_product[0];
        for (int i = 1; i < size; i++) begin
            reg2 <= reg1 + partial_product[i];
        end
        reg1 <= reg2;
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