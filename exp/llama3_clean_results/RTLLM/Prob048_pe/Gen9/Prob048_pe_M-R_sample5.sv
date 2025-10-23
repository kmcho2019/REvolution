module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Multiplier module
module multiplier (
    input [31:0] a,
    input [31:0] b,
    output [31:0] product
);
    assign product = a * b;
endmodule

// Adder module
module adder (
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    assign sum = a + b;
endmodule

// Instantiation of multiplier and adder modules
wire [31:0] product;
wire [31:0] sum;

multiplier mult (.a(a),.b(b),.product(product));
adder add (.a(c_reg),.b(product),.sum(sum));

// Register update logic
reg [31:0] c_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= sum;
    end
end

// Output assignment
assign c = c_reg;

endmodule