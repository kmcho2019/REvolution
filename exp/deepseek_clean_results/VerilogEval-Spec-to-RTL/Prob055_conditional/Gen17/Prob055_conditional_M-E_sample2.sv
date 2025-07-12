module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Combine all inputs into one vector
    wire [31:0] combined = {a, b, c, d};
    
    // Find which inputs are equal to the global minimum
    wire [3:0] is_min;
    assign is_min[0] = (a <= b) & (a <= c) & (a <= d);
    assign is_min[1] = (b <= a) & (b <= c) & (b <= d);
    assign is_min[2] = (c <= a) & (c <= b) & (c <= d);
    assign is_min[3] = (d <= a) & (d <= b) & (d <= c);
    
    // Priority encoder to select first minimum
    wire [1:0] sel;
    assign sel = is_min[0] ? 2'b00 :
                is_min[1] ? 2'b01 :
                is_min[2] ? 2'b10 :
                2'b11;
    
    // Output the selected minimum
    assign min = combined[sel*8 +: 8];

endmodule