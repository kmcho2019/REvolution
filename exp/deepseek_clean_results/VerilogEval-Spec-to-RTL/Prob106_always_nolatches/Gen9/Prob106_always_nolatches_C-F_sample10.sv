module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Internal one-hot encoded signal
    wire [3:0] arrow_keys;
    
    // Check for arrow key prefix (0xE0) first
    wire is_arrow = (scancode[15:8] == 8'he0);
    
    // Parallel comparisons for each arrow key
    wire is_left  = is_arrow & (scancode[7:0] == 8'h6b);
    wire is_down  = is_arrow & (scancode[7:0] == 8'h72);
    wire is_right = is_arrow & (scancode[7:0] == 8'h74);
    wire is_up    = is_arrow & (scancode[7:0] == 8'h75);
    
    // One-hot encoded output
    assign arrow_keys = {is_left, is_down, is_right, is_up};
    
    // Output assignments
    assign left  = arrow_keys[3];
    assign down  = arrow_keys[2];
    assign right = arrow_keys[1];
    assign up    = arrow_keys[0];

endmodule