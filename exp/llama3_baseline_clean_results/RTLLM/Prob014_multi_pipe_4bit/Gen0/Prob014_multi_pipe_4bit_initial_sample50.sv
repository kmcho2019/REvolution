module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

reg [7:0] partial_products [3:0];
reg [7:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 8'd0;
        mul_out <= 8'd0;
        for (int i = 0; i < size; i++) begin
            partial_products[i] <= 8'd0;
        end
    end else begin
        // extend input signals
        reg [7:0] a_ext;
        reg [7:0] b_ext;
        a_ext = {4'd0, mul_a};
        b_ext = {4'd0, mul_b};

        // generate partial products
        for (int i = 0; i < size; i++) begin
            if (b_ext[i]) begin
                partial_products[i] <= a_ext << i;
            end else begin
                partial_products[i] <= 8'd0;
            end
        end

        // add partial products
        reg [7:0] temp_sum;
        temp_sum = 8'd0;
        for (int i = 0; i < size; i++) begin
            temp_sum = temp_sum + partial_products[i];
        end
        sum <= temp_sum;

        // calculate final product
        mul_out <= sum;
    end
end

endmodule