module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

    // Direction encoding: 2-bit signal where each value means:
    // 00 - no arrow
    // 01 - left
    // 10 - down
    // 11 - right
    // (up is handled separately since 2 bits can't encode 4 directions uniquely,
    // so we'll encode up as a separate case.)
    wire [1:0] dir_code;
    wire up_detected;

    // Decode direction based on the full 16-bit scancode
    assign dir_code = (scancode == 16'hE06B) ? 2'b01 :  // left
                      (scancode == 16'hE072) ? 2'b10 :  // down
                      (scancode == 16'hE074) ? 2'b11 :  // right
                      2'b00;

    assign up_detected = (scancode == 16'hE075);

    // Outputs are one-hot based on decoded direction
    assign left  = (dir_code == 2'b01);
    assign down  = (dir_code == 2'b10);
    assign right = (dir_code == 2'b11);
    assign up    = up_detected;

endmodule