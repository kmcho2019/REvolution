module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

reg [7:0] partial_product [3:0];
reg [7:0] reg1;
reg [7:0] reg2;

// Extend input signals by adding "size" number of zero bits at the most significant bit positions
wire [7:0] mul_a_ext = {4'd0, mul_a};
wire [7:0] mul_b_ext = {4'd0, mul_b};

// Use a generate block to perform multiplication for each bit position of the multiplier (mul_b) and generate the partial products
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin
        always @(posedge clk or negedge rst_n) begin
            if (~rst_n) begin
                partial_product[i] <= 8'd0;
            end else begin
                if (mul_b[i] == 1'b1) begin
                    partial_product[i] <= mul_a_ext << i;
                end else begin
                    partial_product[i] <= 8'd0;
                end
            end
        end
    end
endgenerate

// Use registers to store the intermediate sum values and perform add operations
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 8'd0;
        reg2 <= 8'd0;
    end else begin
        reg1 <= partial_product[0] + partial_product[1];
        reg2 <= partial_product[2] + partial_product[3];
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= reg1 + reg2;
    end
end

endmodule