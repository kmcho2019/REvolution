module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Intermediate registers
reg [2*size-1:0] reg1, reg2;

// Extend input signals
wire [2*size-1:0] ext_mul_a = {size{1'b0}} | mul_a;

// Generate partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        wire [2*size-1:0] partial_product = (mul_b[i] == 1'b1)? (ext_mul_a << i) : {2*size{1'b0}};
        
        if (i == 0) begin
            // Initialize reg1 with the first partial product
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    reg1 <= {2*size{1'b0}};
                end else begin
                    reg1 <= partial_product;
                end
            end
        end else begin
            // Add subsequent partial products to reg1
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    reg1 <= {2*size{1'b0}};
                end else begin
                    reg1 <= reg1 + partial_product;
                end
            end
        end
    end
endgenerate

// Second level of registers to store intermediate sum
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg2 <= {2*size{1'b0}};
    end else begin
        reg2 <= reg1;
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= reg2;
    end
end

endmodule