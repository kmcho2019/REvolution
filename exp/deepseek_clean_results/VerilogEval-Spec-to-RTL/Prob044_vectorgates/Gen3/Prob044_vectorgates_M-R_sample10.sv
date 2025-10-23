module TopModule (
    input [2:0] a,
    input [2:0] b,
    output reg [2:0] out_or_bitwise,
    output reg out_or_logical,
    output reg [5:0] out_not
);

    wire [2:0] not_a;
    wire [2:0] not_b;
    wire a_nonzero;
    wire b_nonzero;

    // Compute intermediate values
    assign not_a = ~a;
    assign not_b = ~b;
    assign a_nonzero = |a;
    assign b_nonzero = |b;

    always @(*) begin
        // Bitwise OR
        out_or_bitwise = a | b;
        
        // Logical OR
        out_or_logical = a_nonzero || b_nonzero;
        
        // Concatenated NOT outputs
        out_not = {not_b, not_a};
    end

endmodule