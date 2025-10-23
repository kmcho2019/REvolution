module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] reg1, reg2;
reg [2*size-1:0] partial_products [size-1:0];

integer i;

// generate partial products
genvar j;
generate
    for(j = 0; j < size; j = j + 1) begin
        always @(mul_a, mul_b) begin
            if(mul_b[j]) begin
                partial_products[j] = {size{1'b0}} << j;
                for(i = 0; i < size; i = i + 1) begin
                    partial_products[j][i+j] = mul_a[i];
                end
            end else begin
                partial_products[j] = 'd0;
            end
        end
    end
endgenerate

// first level of registers
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        reg1 <= 'd0;
    end else begin
        reg1 <= 'd0;
        for(i = 0; i < size; i = i + 1) begin
            reg1 <= reg1 + partial_products[i];
        end
    end
end

// second level of registers
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        reg2 <= 'd0;
    end else begin
        reg2 <= reg1;
    end
end

// final product calculation
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mul_out <= 'd0;
    end else begin
        mul_out <= reg2;
    end
end

endmodule