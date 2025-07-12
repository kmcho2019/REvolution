module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal signals as signed
    reg signed [N-1:0] a_signed;
    reg signed [N-1:0] b_signed;
    reg signed [N-1:0] sum;
    wire overflow_positive;
    wire overflow_negative;

    always @(*) begin
        // Convert to signed
        a_signed = a;
        b_signed = b;
        
        // Perform signed addition
        sum = a_signed + b_signed;
        
        // Detect overflow
        overflow_positive = (~a_signed[N-1] & ~b_signed[N-1] & sum[N-1]);
        overflow_negative = (a_signed[N-1] & b_signed[N-1] & ~sum[N-1]);
        
        // Handle overflow with saturation
        if (overflow_positive) begin
            c = {1'b0, {(N-1){1'b1}}};  // Max positive
        end else if (overflow_negative) begin
            c = {1'b1, {(N-1){1'b0}}};   // Min negative
        end else begin
            c = sum;
        end
    end

endmodule