module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [15:0] partial_products [15:0];
reg [31:0] sum;
reg [31:0] carry;
reg done_r;

always @(posedge clk) begin
    if (!rst_n) begin
        sum <= 32'd0;
        carry <= 32'd0;
        done_r <= 1'b0;
    end else if (start) begin
        // Generate partial products
        for (int i = 0; i < 16; i++) begin
            if (bin[i] == 1'b1) begin
                partial_products[i] <= ain << i;
            end else begin
                partial_products[i] <= 16'd0;
            end
        end
        
        // Add partial products using carry-save adder array
        for (int i = 0; i < 16; i++) begin
            sum <= sum + partial_products[i];
            carry <= carry + (partial_products[i] >> 16);
        end
        
        // Check if multiplication is complete
        if (carry == 32'd0 && sum == 32'd0) begin
            done_r <= 1'b1;
        end
    end
end

assign yout = {carry, sum[15:0]};
assign done = done_r;

endmodule