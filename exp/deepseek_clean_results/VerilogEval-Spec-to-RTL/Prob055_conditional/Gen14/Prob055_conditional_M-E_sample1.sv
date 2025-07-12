module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Flags indicating if each input is still a candidate for minimum
    reg a_is_min, b_is_min, c_is_min, d_is_min;
    
    always @(*) begin
        // Initialize all as potential minimums
        a_is_min = 1'b1;
        b_is_min = 1'b1;
        c_is_min = 1'b1;
        d_is_min = 1'b1;
        
        // Perform all pairwise comparisons in parallel
        if (a > b) a_is_min = 1'b0;
        if (a > c) a_is_min = 1'b0;
        if (a > d) a_is_min = 1'b0;
        
        if (b > a) b_is_min = 1'b0;
        if (b > c) b_is_min = 1'b0;
        if (b > d) b_is_min = 1'b0;
        
        if (c > a) c_is_min = 1'b0;
        if (c > b) c_is_min = 1'b0;
        if (c > d) c_is_min = 1'b0;
        
        if (d > a) d_is_min = 1'b0;
        if (d > b) d_is_min = 1'b0;
        if (d > c) d_is_min = 1'b0;
    end
    
    // Select the minimum value based on the flags
    assign min = (a_is_min) ? a :
                 (b_is_min) ? b :
                 (c_is_min) ? c :
                 d;

endmodule