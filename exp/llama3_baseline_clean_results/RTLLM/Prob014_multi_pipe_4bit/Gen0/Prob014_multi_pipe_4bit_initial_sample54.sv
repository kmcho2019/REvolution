module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

    reg [2*size-1:0] partial_product [size];
    reg [2*size-1:0] sum_reg1;
    reg [2*size-1:0] sum_reg2;

    // Extend input signals by adding size number of zero bits at the most significant bit positions
    wire [2*size-1:0] mul_a_ext = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] mul_b_ext = { {size{1'b0}}, mul_b };

    // Generate block to perform multiplication for each bit position of the multiplier
    genvar i;
    generate
        for (i = 0; i < size; i++) begin
            assign partial_product[i] = (mul_b_ext[i] == 1'b1) ? (mul_a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // Update sum registers on the positive edge of the clock signal or the falling edge of the reset signal
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg1 <= {2*size{1'b0}};
            sum_reg2 <= {2*size{1'b0}};
        end else begin
            sum_reg1 <= partial_product[0] + (i == 0 ? {2*size{1'b0}} : partial_product[1]);
            sum_reg2 <= (sum_reg1 + partial_product[2]) + partial_product[3];
        end
    end

    // Calculate the final product
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= sum_reg2;
        end
    end

endmodule