module pe #(
    parameter WIDTH = 32
) (
    input wire clk,
    input wire rst,
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output reg signed [WIDTH-1:0] c
);

    // Full precision multiplication result
    wire signed [2*WIDTH-1:0] product;
    assign product = a * b;

    // Registered accumulation with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            c <= {WIDTH{1'b0}};  // Clear all bits
        end else begin
            c <= c + product[WIDTH-1:0];  // Truncated accumulation
        end
    end

    // Optional: Overflow detection
    // wire overflow = (product > (2**(WIDTH-1)-1)) || (product < -(2**(WIDTH-1)));

endmodule