module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

// Parameter definition
parameter size = 4;

// Extend input signals by adding size number of zero bits
wire [7:0] mul_a_ext = {4'd0, mul_a};
wire [7:0] mul_b_ext = {4'd0, mul_b};

// Generate block for partial products
reg [7:0] partial_product [3:0];
reg [7:0] sum_reg1;
reg [7:0] sum_reg2;
reg [7:0] mul_out_reg;

integer i;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition
        for (i = 0; i < size; i++) begin
            partial_product[i] <= 8'd0;
        end
        sum_reg1 <= 8'd0;
        sum_reg2 <= 8'd0;
        mul_out_reg <= 8'd0;
    end else begin
        // Calculate partial products
        for (i = 0; i < size; i++) begin
            if (mul_b_ext[i] == 1'b1) begin
                partial_product[i] <= mul_a_ext << i;
            end else begin
                partial_product[i] <= 8'd0;
            end
        end
        
        // Update sum register 1
        sum_reg1 <= partial_product[0] + partial_product[1];
        
        // Update sum register 2
        sum_reg2 <= sum_reg1 + partial_product[2] + partial_product[3];
        
        // Update product output
        mul_out_reg <= sum_reg2;
    end
end

// Assign output
assign mul_out = mul_out_reg;

endmodule