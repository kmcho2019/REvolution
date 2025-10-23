module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    // Internal signals
    wire signed [31:0] product;
    wire signed [31:0] next_c;
    reg signed [31:0] current_c;

    // Combinational logic
    assign product = a * b;  // 32x32 multiplier
    assign next_c = current_c + product;  // Accumulator
    assign c = current_c;  // Output assignment

    // Sequential logic
    always @(posedge clk) begin
        if (rst) begin
            current_c <= 32'd0;
        end else begin
            current_c <= next_c;
        end
    end

endmodule