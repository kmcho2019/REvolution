module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

    // Define the size of the input signals
    parameter size = 4;

    // Extend the input signals by adding "size" number of zero bits at the most significant bit positions
    wire [7:0] mul_a_ext = {4'd0, mul_a};
    wire [7:0] mul_b_ext = {4'd0, mul_b};

    // Declare registers to store intermediate sum values
    reg [7:0] reg1;
    reg [7:0] reg2;

    // Initialize the registers on reset
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg1 <= 8'd0;
            reg2 <= 8'd0;
        end else begin
            // Calculate partial products for each bit position of the multiplier
            reg1 <= 8'd0;
            for (int i = 0; i < size; i++) begin
                if (mul_b_ext[i]) begin
                    reg1 <= reg1 + (mul_a_ext << i);
                end
            end

            // Update the second register with the sum of the corresponding partial products
            reg2 <= reg1;
        end
    end

    // Calculate the final product
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_out <= 8'd0;
        end else begin
            mul_out <= reg2;
        end
    end

endmodule