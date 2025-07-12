module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

// Internal signals in two's complement format
wire signed [N-1:0] a_tc = a;
wire signed [N-1:0] b_tc = b;
reg signed [N-1:0] res_tc;

// Overflow detection signals
wire overflow_pos = (~a_tc[N-1] & b_tc[N-1] & res_tc[N-1]) |  // a+ - b- → positive overflow
                   (a_tc[N-1] & ~b_tc[N-1] & ~res_tc[N-1]);   // a- - b+ → negative overflow

wire overflow_neg = (~a_tc[N-1] & b_tc[N-1] & res_tc[N-1]) |   // a+ - b- → negative overflow
                   (a_tc[N-1] & ~b_tc[N-1] & ~res_tc[N-1]);    // a- - b+ → positive overflow

always @(*) begin
    // Perform two's complement subtraction
    res_tc = a_tc - b_tc;
    
    // Handle overflow cases
    if (overflow_pos) begin
        res_tc = {1'b0, {(N-1){1'b1}}};  // Saturate to maximum positive
    end
    else if (overflow_neg) begin
        res_tc = {1'b1, {(N-1){1'b0}}};  // Saturate to minimum negative
    end
    
    // Explicit zero handling
    if (res_tc == 0) begin
        res_tc[N-1] = 1'b0;  // Force positive zero
    end
    
    // Rounding for fractional bits (optional)
    // res_tc = res_tc + (1 << (Q-1));  // Round to nearest
    
    c = res_tc;
end

endmodule