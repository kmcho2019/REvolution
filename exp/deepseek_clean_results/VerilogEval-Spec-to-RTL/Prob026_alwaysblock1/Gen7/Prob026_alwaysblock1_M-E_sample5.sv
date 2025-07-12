module TopModule #(
    parameter WIDTH = 1
) (
    input wire [WIDTH-1:0] a,
    input wire [WIDTH-1:0] b,
    output wire [WIDTH-1:0] out_assign,
    output reg [WIDTH-1:0] out_alwaysblock
);

    // Assign implementation using bitwise AND
    assign out_assign = a & b;

    // Always block implementation with ternary operator
    always @(*) begin
        out_alwaysblock = (a == {WIDTH{1'b1}} && b == {WIDTH{1'b1}}) ? {WIDTH{1'b1}} : {WIDTH{1'b0}};
    end

    // Generate block for demonstration (though not strictly needed for 1-bit)
    generate
        if (WIDTH > 1) begin
            // Additional logic for multi-bit case
            // Not used in this 1-bit implementation but shows scalability
        end
    endgenerate

endmodule