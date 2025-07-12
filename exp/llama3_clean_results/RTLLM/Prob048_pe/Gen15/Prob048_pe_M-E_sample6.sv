module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Pipelined Multiplier
reg [31:0] mult_a, mult_b;
reg [31:0] partial_product;
reg [1:0] mult_stage;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        mult_a <= 32'd0;
        mult_b <= 32'd0;
        partial_product <= 32'd0;
        mult_stage <= 2'd0;
    end else begin
        case (mult_stage)
            2'd0: begin
                mult_a <= a;
                mult_b <= b;
                partial_product <= 32'd0;
                mult_stage <= 2'd1;
            end
            2'd1: begin
                partial_product <= mult_a * mult_b;
                mult_stage <= 2'd2;
            end
            2'd2: begin
                // Accumulation
                c <= c + partial_product;
                mult_stage <= 2'd0;
            end
        endcase
    end
end

// Accumulator Register
reg [31:0] c;

initial c = 32'd0;

// Output Assignment
assign c = c;

endmodule