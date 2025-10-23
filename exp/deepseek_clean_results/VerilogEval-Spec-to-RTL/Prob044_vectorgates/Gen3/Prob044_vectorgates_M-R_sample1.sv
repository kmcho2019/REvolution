module TopModule (
    input [2:0] a,
    input [2:0] b,
    output reg [2:0] out_or_bitwise,
    output reg out_or_logical,
    output reg [5:0] out_not
);

    wire [2:0] not_a, not_b;
    wire [2:0] bitwise_or;

    // Compute intermediate values
    assign not_a = ~a;
    assign not_b = ~b;
    assign bitwise_or = a | b;

    always @(*) begin
        // Bitwise OR output
        out_or_bitwise = bitwise_or;
        
        // Logical OR output (reduce the bitwise OR)
        out_or_logical = |bitwise_or;
        
        // Concatenated NOT outputs
        out_not = {not_b, not_a};
    end

endmodule