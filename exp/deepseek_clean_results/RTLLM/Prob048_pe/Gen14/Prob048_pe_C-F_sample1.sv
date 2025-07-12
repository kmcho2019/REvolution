module pe #(
    parameter WIDTH = 32
) (
    input wire clk,
    input wire rst,
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output wire signed [WIDTH-1:0] c
);

    // Internal signals
    reg signed [WIDTH-1:0] acc_reg;
    wire signed [2*WIDTH-1:0] product;
    wire signed [WIDTH-1:0] next_acc;

    // Combinational logic
    assign product = a * b;
    assign next_acc = acc_reg + product[WIDTH-1:0];  // Truncated accumulation
    assign c = acc_reg;  // Continuous output assignment

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            acc_reg <= {WIDTH{1'b0}};  // Parameterized reset
        end else begin
            acc_reg <= next_acc;
        end
    end

endmodule