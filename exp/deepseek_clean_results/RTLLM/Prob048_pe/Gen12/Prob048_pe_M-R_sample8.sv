module pe #(
    parameter WIDTH = 32
) (
    input wire clk,
    input wire rst,
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output reg signed [WIDTH-1:0] c
);

    // Intermediate signals
    wire signed [2*WIDTH-1:0] product;
    wire signed [WIDTH-1:0] next_c;

    // Combinational logic
    assign product = a * b;
    assign next_c = c + product[WIDTH-1:0];  // Truncated accumulation

    // Sequential logic
    always @(posedge clk) begin
        if (rst) begin
            c <= {WIDTH{1'b0}};  // Reset to zero
        end else begin
            c <= next_c;        // Update with new accumulated value
        end
    end

endmodule