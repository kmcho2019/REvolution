module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [31:0] partial_products [15:0];
reg [31:0] sum;
reg [31:0] carry;
reg done_r;

assign yout = sum;
assign done = done_r;

always @(posedge clk) begin
    if (!rst_n) begin
        sum <= 32'd0;
        carry <= 32'd0;
        done_r <= 1'b0;
    end else if (start) begin
        // Generate partial products
        for (int i = 0; i < 16; i++) begin
            partial_products[i] <= (bin << i) & {16{ain[i]}};
        end

        // Carry-save adder tree
        sum <= partial_products[0];
        carry <= 32'd0;
        for (int i = 1; i < 16; i++) begin
            {carry, sum} <= sum + partial_products[i] + carry;
        end

        // Final adder
        {carry, sum} <= sum + carry;

        done_r <= 1'b1;
    end else begin
        sum <= 32'd0;
        carry <= 32'd0;
        done_r <= 1'b0;
    end
end

endmodule