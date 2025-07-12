module multi_pipe_4bit (
    input clk,    // Clock signal
    input rst_n,  // Active-low reset signal
    input [3:0] mul_a,  // Multiplicand
    input [3:0] mul_b,  // Multiplier
    output [7:0] mul_out  // Product output
);

parameter size = 4;

// Extend the input signals by adding "size" number of zero bits at the most significant bit positions
wire [7:0] extended_mul_a = {4'd0, mul_a};
wire [7:0] extended_mul_b = {4'd0, mul_b};

// Registers to store the intermediate sum values
reg [7:0] reg1;
reg [7:0] reg2;

// Generate block to perform multiplication for each bit position of the multiplier
genvar i;
generate
    for (i = 0; i < size; i++) begin: partial_product_gen
        // Calculate the partial product
        wire [7:0] partial_product;
        assign partial_product = (mul_b[i] == 1'd1) ? extended_mul_a << i : 8'd0;

        // Perform add operations on the positive edge of the clock signal or the falling edge of the reset signal
        if (i == 0) begin
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    reg1 <= 8'd0;
                end else begin
                    reg1 <= partial_product;
                end
            end
        end else if (i == 1) begin
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    reg2 <= 8'd0;
                end else begin
                    reg2 <= reg1 + partial_product;
                end
            end
        end else if (i == 2) begin
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    reg1 <= 8'd0;
                end else begin
                    reg1 <= reg2 + partial_product;
                end
            end
        end else if (i == 3) begin
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    mul_out <= 8'd0;
                end else begin
                    mul_out <= reg1 + partial_product;
                end
            end
        end
    end
endgenerate

endmodule