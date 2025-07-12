module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;
reg [3:0] multiplier_seg1;
reg [3:0] multiplier_seg2;
reg [15:0] product_seg1;
reg [15:0] product_seg2;
reg [15:0] final_product;
reg [1:0] state;
reg enable;

// Clock gating
always @(posedge clk) begin
    if (reset) begin
        enable <= 0;
    end else if (state == 2'b00) begin
        enable <= 1;
    end else if (state == 2'b10) begin
        enable <= 0;
    end
end

// Parallel multiplier array
always @(posedge clk) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier_seg1 <= 0;
        multiplier_seg2 <= 0;
        product_seg1 <= 0;
        product_seg2 <= 0;
        state <= 2'b00;
    end else if (enable) begin
        case (state)
            2'b00: begin
                // Initialize the registers
                multiplicand <= {{8{a[7]}}, a};
                multiplier_seg1 <= b[7:4];
                multiplier_seg2 <= b[3:0];
                state <= 2'b01;
            end
            2'b01: begin
                // Perform the multiplication process in parallel
                product_seg1 <= booth_multiplier(multiplicand, multiplier_seg1);
                product_seg2 <= booth_multiplier(multiplicand, multiplier_seg2);
                state <= 2'b10;
            end
            2'b10: begin
                // Add the results from the two multiplier units
                final_product <= product_seg1 + (product_seg2 << 4);
                p <= final_product;
                rdy <= 1;
                state <= 2'b00;
            end
            default: begin
                state <= 2'b00;
            end
        endcase
    end
end

// Modified Booth multiplier
function [15:0] booth_multiplier;
    input [15:0] multiplicand;
    input [3:0] multiplier;
    reg [15:0] product;
    reg [3:0] i;
begin
    product = 0;
    for (i = 0; i < 4; i = i + 1) begin
        if (multiplier[i] == 1) begin
            product = product + (multiplicand << i);
        end
    end
    booth_multiplier = product;
end
endfunction

endmodule