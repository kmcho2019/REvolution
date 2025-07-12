module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

    reg [7:0] sum_reg1;
    reg [7:0] sum_reg2;
    wire [7:0] partial_products [3:0];

    // Extend input signals by adding "size" number of zero bits at the most significant bit positions
    wire [7:0] extended_mul_a = {4'd0, mul_a};
    wire [7:0] extended_mul_b = {4'd0, mul_b};

    // Generate block to perform multiplication for each bit position of the multiplier
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            assign partial_products[i] = (extended_mul_b[i] == 1'b1) ? (extended_mul_a << i) : 8'd0;
        end
    endgenerate

    // Add partial products and store intermediate sum values in registers
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum_reg1 <= 8'd0;
        end else begin
            sum_reg1 <= partial_products[0] + partial_products[1];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum_reg2 <= 8'd0;
        end else begin
            sum_reg2 <= sum_reg1 + partial_products[2] + partial_products[3];
        end
    end

    // Calculate final product and update product output
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_out <= 8'd0;
        end else begin
            mul_out <= sum_reg2;
        end
    end

endmodule