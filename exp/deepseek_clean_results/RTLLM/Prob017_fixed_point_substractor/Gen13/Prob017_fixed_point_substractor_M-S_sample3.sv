module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Treat inputs as signed for arithmetic
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    always @(*) begin
        if (a == b) begin
            c = {N{1'b0}};  // Handle zero case
        end else begin
            c = a_signed - b_signed;  // Direct subtraction
        end
    end

endmodule