module pe #(
    parameter WIDTH = 32
) (
    input wire clk,
    input wire rst,
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output reg signed [WIDTH-1:0] c
);

    // Full precision multiplication
    wire signed [2*WIDTH-1:0] product = a * b;
    
    // Next accumulation value
    wire signed [WIDTH-1:0] next_c = c + product[WIDTH-1:0];

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            c <= {WIDTH{1'b0}};
        end else begin
            c <= next_c;
        end
    end

    // Optional: Overflow detection
    // wire overflow = (product > (2**(WIDTH-1)-1) || (product < -(2**(WIDTH-1)));

endmodule