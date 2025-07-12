module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Multiplier Cell (MC)
module multiplier_cell(
    input clk,
    input reset,
    input [15:0] multiplicand,
    input [1:0] multiplier_bit,
    input [15:0] partial_product,
    output reg [15:0] next_multiplicand,
    output reg [15:0] next_partial_product
);

reg [15:0] multiplicand_reg;
reg [1:0] multiplier_bit_reg;
reg [15:0] partial_product_reg;

always @(posedge clk) begin
    if(reset) begin
        multiplicand_reg <= 0;
        multiplier_bit_reg <= 0;
        partial_product_reg <= 0;
    end else begin
        multiplicand_reg <= multiplicand;
        multiplier_bit_reg <= multiplier_bit;
        partial_product_reg <= partial_product;
    end
end

always @(*) begin
    if(multiplier_bit_reg == 2'b01) begin
        next_multiplicand = multiplicand_reg << 1;
        next_partial_product = partial_product_reg + multiplicand_reg;
    end else if(multiplier_bit_reg == 2'b10) begin
        next_multiplicand = multiplicand_reg << 1;
        next_partial_product = partial_product_reg - multiplicand_reg;
    end else begin
        next_multiplicand = multiplicand_reg << 1;
        next_partial_product = partial_product_reg;
    end
end

endmodule

// Systolic Array (SA)
reg [15:0] multiplicand [7:0];
reg [1:0] multiplier_bit [7:0];
reg [15:0] partial_product [7:0];

always @(posedge clk) begin
    if(reset) begin
        multiplicand[0] <= { {8{b[7]}}, b };
        multiplier_bit[0] <= a[7:6];
        partial_product[0] <= 0;
    end else begin
        for(int i = 0; i < 7; i++) begin
            multiplicand[i+1] <= multiplicand[i] << 1;
            multiplier_bit[i+1] <= a[7-i-1:6-i];
            partial_product[i+1] <= partial_product[i] + (multiplier_bit[i] == 2'b01? multiplicand[i] : 0) - (multiplier_bit[i] == 2'b10? multiplicand[i] : 0);
        end
    end
end

// Root Cell (RC)
always @(posedge clk) begin
    if(reset) begin
        p <= 0;
        rdy <= 0;
    end else begin
        p <= partial_product[7];
        rdy <= 1;
    end
end

endmodule