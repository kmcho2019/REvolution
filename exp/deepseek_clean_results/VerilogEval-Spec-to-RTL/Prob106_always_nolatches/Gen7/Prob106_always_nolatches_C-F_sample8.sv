module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Combine outputs into a single vector
    wire [3:0] arrow_keys = {
        left, down, right, up
    };

    // Check for E0 prefix (11100000) using bitwise operations
    wire is_extended = &{scancode[15:13], ~scancode[12:8]};

    // Decode arrow keys
    assign arrow_keys = is_extended ? 
        (scancode[7:0] == 8'h6b) ? 4'b1000 :  // left
        (scancode[7:0] == 8'h72) ? 4'b0100 :  // down
        (scancode[7:0] == 8'h74) ? 4'b0010 :  // right
        (scancode[7:0] == 8'h75) ? 4'b0001 :  // up
        4'b0000 : 4'b0000;

endmodule