module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Define the number of processing elements (PEs) in the systolic array
parameter NUM_PEs = 4;

// Define the width of the input operands
parameter INPUT_WIDTH = 32;

// Define the width of the partial products
parameter PARTIAL_PRODUCT_WIDTH = 16;

// Input buffering
reg [INPUT_WIDTH-1:0] a_reg;
reg [INPUT_WIDTH-1:0] b_reg;

// Systolic array
reg [PARTIAL_PRODUCT_WIDTH-1:0] partial_products [NUM_PEs-1:0];

// Partial product generation
always @(posedge clk) begin
    if (rst) begin
        a_reg <= 32'd0;
        b_reg <= 32'd0;
    end else begin
        a_reg <= a;
        b_reg <= b;
    end
end

// Accumulation
always @(posedge clk) begin
    if (rst) begin
        for (int i = 0; i < NUM_PEs; i++) begin
            partial_products[i] <= 16'd0;
        end
    end else begin
        for (int i = 0; i < NUM_PEs; i++) begin
            if (i == 0) begin
                partial_products[i] <= a_reg[7:0] * b_reg[7:0];
            end else begin
                partial_products[i] <= partial_products[i-1] + (a_reg[(i*8)+7:(i*8)] * b_reg[(i*8)+7:(i*8)]);
            end
        end
    end
end

// Output generation
always @(posedge clk) begin
    if (rst) begin
        c <= 32'd0;
    end else begin
        c <= partial_products[NUM_PEs-1];
    end
end

endmodule