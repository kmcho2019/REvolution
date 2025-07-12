module multi_pipe_4bit #(
    parameter size = 4
)(
    input             clk,
    input             rst_n,
    input  [size-1:0]  mul_a,
    input  [size-1:0]  mul_b,
    output [2*size-1:0] mul_out
);

    reg  [2*size-1:0] mul_out_reg;
    reg  [2*size-1:0] partial_product [size-1:0];
    reg  [2*size-1:0] sum [size-1:0];

    // Extend input signals by adding zeros at the most significant bit positions
    wire [2*size-1:0] mul_a_ext = {size'd0, mul_a};
    wire [2*size-1:0] mul_b_ext = {size'd0, mul_b};

    // Generate partial products for each bit position of the multiplier
    genvar i;
    generate
        for (i = 0; i < size; i++) begin
            if (mul_b_ext[i] == 1'b1) begin
                assign partial_product[i] = mul_a_ext << i;
            end else begin
                assign partial_product[i] = 'd0;
            end
        end
    endgenerate

    // Perform add operations on the positive edge of the clock signal or the falling edge of the reset signal
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Reset registers
            for (int i = 0; i < size; i++) begin
                sum[i] <= 'd0;
            end
            mul_out_reg <= 'd0;
        end else begin
            // Update registers
            sum[0] <= partial_product[0];
            for (int i = 1; i < size; i++) begin
                sum[i] <= sum[i-1] + partial_product[i];
            end
            mul_out_reg <= sum[size-1];
        end
    end

    // Output the final product
    assign mul_out = mul_out_reg;

endmodule