module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Define the size of the input signals
parameter size = 4;

// Define the registers to store the intermediate sum values
reg [7:0] reg1;
reg [7:0] reg2;

// Initialize the registers
initial begin
    reg1 = 8'd0;
    reg2 = 8'd0;
end

// Perform the multiplication operation and calculate the partial products
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the registers and the product output to 0
        reg1 <= 8'd0;
        reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // Calculate the partial products
        reg [7:0] partial_products;
        integer i;
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_products = partial_products + (mul_a << i);
            end
        end

        // Update the registers with the sum of the corresponding partial products
        reg1 <= partial_products;
        reg2 <= reg1;

        // Calculate the final product
        mul_out <= reg2;
    end
end

endmodule