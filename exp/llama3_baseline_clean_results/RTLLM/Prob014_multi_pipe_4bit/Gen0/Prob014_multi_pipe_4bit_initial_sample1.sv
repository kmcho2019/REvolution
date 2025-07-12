module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

    reg [7:0] temp1;
    reg [7:0] temp2;

    // Extend input signals by adding 4 zero bits at the most significant bit positions
    wire [7:0] extended_a = {4'b0000, mul_a};
    wire [7:0] extended_b = {4'b0000, mul_b};

    // Generate block to perform multiplication for each bit position of the multiplier
    wire [7:0] partial_product [3:0];
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            assign partial_product[i] = (extended_b[i] == 1'b1) ? extended_a << i : 8'b0;
        end
    endgenerate

    // Add partial products and store intermediate sum values in registers
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            temp1 <= 8'b0;
            temp2 <= 8'b0;
        end else begin
            temp1 <= partial_product[0] + partial_product[1];
            temp2 <= partial_product[2] + partial_product[3];
        end
    end

    // Calculate final product and update product output
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_out <= 8'b0;
        end else begin
            mul_out <= temp1 + temp2;
        end
    end

endmodule