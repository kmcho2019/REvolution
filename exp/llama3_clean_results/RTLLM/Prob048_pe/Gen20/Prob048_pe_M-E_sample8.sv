module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Booth's Multiplier
reg [31:0] booth_partial_product [31:0];
reg [31:0] booth_product;

always @(posedge clk) begin
    if (rst) begin
        booth_product <= 32'd0;
    end else begin
        booth_product <= 32'd0;
        for (int i = 0; i < 32; i++) begin
            if (b[i] == 1'b1) begin
                booth_partial_product[i] <= a << i;
            end else begin
                booth_partial_product[i] <= 32'd0;
            end
        end
    end
end

// Wallace Tree Adder
reg [31:0] wallace_adder_result;

always @(posedge clk) begin
    if (rst) begin
        wallace_adder_result <= 32'd0;
    end else begin
        wallace_adder_result <= 32'd0;
        for (int i = 0; i < 32; i++) begin
            wallace_adder_result <= wallace_adder_result + booth_partial_product[i];
        end
    end
end

// Accumulator
reg [31:0] c_reg;

always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + wallace_adder_result;
    end
end

assign c = c_reg;

endmodule