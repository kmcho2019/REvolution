module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;  // Register to store the accumulated result
reg [31:0] a_reg;  // Register to store operand A
reg [31:0] b_reg;  // Register to store operand B
reg [4:0] count;  // Counter for the multiplication process
reg [31:0] prod;  // Register to store the product

// Assign output to the register
assign c = c_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all registers and counter
        c_reg <= 32'd0;
        a_reg <= 32'd0;
        b_reg <= 32'd0;
        count <= 5'd0;
        prod <= 32'd0;
    end else begin
        if (count == 5'd0) begin
            // Initialize registers with input operands
            a_reg <= a;
            b_reg <= b;
            count <= 5'd1;
            prod <= 32'd0;
        end else if (count < 5'd32) begin
            // Perform shift-and-add multiplication
            if (a_reg[31 - count] == 1'b1) begin
                prod <= prod + (b_reg << count);
            end
            count <= count + 1'b1;
        end else begin
            // Accumulate the product into the result register
            c_reg <= c_reg + prod;
            count <= 5'd0;
        end
    end
end

endmodule