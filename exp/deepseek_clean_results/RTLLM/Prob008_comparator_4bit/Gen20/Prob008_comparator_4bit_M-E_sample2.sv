module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bitwise equality signals
    wire [3:0] eq = ~(A ^ B);
    
    // Bitwise difference indicators (1 means A > B at this position)
    wire [3:0] diff = A & ~B;
    
    // Thermometer-coded difference indicators
    wire [3:0] therm = {
        diff[3],
        eq[3] & diff[2],
        &eq[3:2] & diff[1],
        &eq[3:1] & diff[0]
    };
    
    // Priority encoder to find first difference
    wire first_diff = |therm;
    wire first_diff_is_greater = |(therm & {4{first_diff}});
    
    // Output logic
    assign A_equal = &eq;
    assign A_greater = first_diff & first_diff_is_greater;
    assign A_less = first_diff & ~first_diff_is_greater;

endmodule