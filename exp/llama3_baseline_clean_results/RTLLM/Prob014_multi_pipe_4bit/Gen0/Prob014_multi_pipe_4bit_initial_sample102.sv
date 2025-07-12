module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

    // Extend the input signals by adding "size" number of zero bits at the most significant bit positions
    wire [2*size-1:0] mul_a_ext = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] mul_b_ext = { {size{1'b0}}, mul_b };

    // Declare the registers to store the intermediate sum values
    reg [2*size-1:0] reg1;
    reg [2*size-1:0] reg2;

    // Initialize the registers and the product output
    initial begin
        reg1 = 'd0;
        reg2 = 'd0;
        mul_out = 'd0;
    end

    // Generate the partial products for each bit position of the multiplier
    genvar i;
    generate
        for (i = 0; i < size; i++) begin
            wire [2*size-1:0] partial_product;
            assign partial_product = (mul_b[i] == 1'b1) ? (mul_a << i) : 'd0;

            // Update the registers on the positive edge of the clock signal or the falling edge of the reset signal
            always @ (posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    reg1 <= 'd0;
                    reg2 <= 'd0;
                    mul_out <= 'd0;
                end else begin
                    if (i == 0) begin
                        reg1 <= partial_product;
                    end else if (i == 1) begin
                        reg1 <= reg1 + partial_product;
                    end else begin
                        reg2 <= reg2 + partial_product;
                    end
                end
            end
        end
    endgenerate

    // Calculate the final product by summing up the partial products
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 'd0;
        end else begin
            mul_out <= reg1 + reg2;
        end
    end

endmodule