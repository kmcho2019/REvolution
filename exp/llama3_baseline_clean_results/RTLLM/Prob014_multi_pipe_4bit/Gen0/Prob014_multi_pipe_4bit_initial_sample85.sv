module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

// Extend input signals by adding "size" number of zero bits
wire [7:0] ext_mul_a = {4'd0, mul_a};
wire [7:0] ext_mul_b = {4'd0, mul_b};

// Initialize intermediate sum registers
reg [7:0] sum_reg1;
reg [7:0] sum_reg2;

// Initialize output register
reg [7:0] mul_out_reg;

// Generate block for partial products
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin
        // Calculate partial product
        wire [7:0] partial_product = (ext_mul_b[i] == 1'd1)? (ext_mul_a << i) : 8'd0;

        // Update intermediate sum registers
        if (i == 0) begin
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    sum_reg1 <= 8'd0;
                end else begin
                    sum_reg1 <= partial_product;
                end
            end
        end else if (i == 1) begin
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    sum_reg1 <= 8'd0;
                end else begin
                    sum_reg1 <= sum_reg1 + partial_product;
                end
            end
        end else if (i == 2) begin
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    sum_reg2 <= 8'd0;
                end else begin
                    sum_reg2 <= partial_product;
                end
            end
        end else if (i == 3) begin
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    sum_reg2 <= 8'd0;
                end else begin
                    sum_reg2 <= sum_reg2 + partial_product;
                end
            end
        end
    end
endgenerate

// Update output register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 8'd0;
    end else begin
        mul_out_reg <= sum_reg1 + sum_reg2;
    end
end

// Assign output
assign mul_out = mul_out_reg;

endmodule