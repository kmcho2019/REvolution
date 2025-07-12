module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_product [size-1:0];
reg [2*size-1:0] sum1, sum2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1 <= 'd0;
        sum2 <= 'd0;
        mul_out <= 'd0;
    end else begin
        // extend input signals by adding size number of zero bits at the most significant bit positions
        reg [2*size-1:0] a_ext = {mul_a, {size{1'b0}}};
        reg [2*size-1:0] b_ext = {mul_b, {size{1'b0}}};
        
        // generate partial products for each bit position of the multiplier
        for (genvar i = 0; i < size; i++) begin
            if (b_ext[i]) begin
                partial_product[i] = a_ext << i;
            end else begin
                partial_product[i] = 'd0;
            end
        end
        
        // add partial products using registers to store intermediate sum values
        sum1 <= partial_product[0] + (i == 1 ? partial_product[1] : 'd0);
        sum2 <= (i == 1 ? sum1 : 'd0) + partial_product[2] + partial_product[3];
        
        // calculate the final product based on the sum of registers
        mul_out <= sum2;
    end
end

endmodule