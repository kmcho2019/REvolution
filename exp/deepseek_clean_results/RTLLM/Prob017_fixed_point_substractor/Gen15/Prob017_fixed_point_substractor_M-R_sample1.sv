module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total bit width
) (
    input wire [N-1:0] a,  // First fixed-point operand
    input wire [N-1:0] b,  // Second fixed-point operand
    output reg [N-1:0] c   // Subtraction result
);

    localparam INT_BITS = N - Q;  // Integer bits

    always @(*) begin
        // Convert to signed for arithmetic
        reg signed [N-1:0] a_signed = a;
        reg signed [N-1:0] b_signed = b;
        reg signed [N-1:0] res;
        
        // Perform the subtraction
        res = a_signed - b_signed;
        
        // Handle zero case explicitly
        if (res == 0) begin
            c = {1'b0, {N-1{1'b0}}};  // Force positive zero
        end
        else begin
            c = res;
        end
    end

endmodule