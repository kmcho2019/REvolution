module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32    // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal signals for signed arithmetic
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    wire signed [N:0] extended_result;  // Extra bit for overflow detection
    
    // Main arithmetic operation with extra bit
    assign extended_result = a_signed - b_signed;
    
    // Overflow/underflow detection
    wire overflow = ~a_signed[N-1] & b_signed[N-1] & extended_result[N];
    wire underflow = a_signed[N-1] & ~b_signed[N-1] & ~extended_result[N];
    
    always @(*) begin
        // Handle overflow cases
        if (overflow) begin
            c = {1'b0, {(N-1){1'b1}}};  // Max positive
        end
        else if (underflow) begin
            c = {1'b1, {(N-1){1'b0}}};   // Max negative
        end
        else if (extended_result == 0) begin
            c = 0;  // Explicit zero handling
        end
        else begin
            c = extended_result[N-1:0];  // Normal case
        end
    end

endmodule