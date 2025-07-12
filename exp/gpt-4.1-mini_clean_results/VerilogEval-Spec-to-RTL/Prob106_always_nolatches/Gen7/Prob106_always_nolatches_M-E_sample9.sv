module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

    // One-hot vector indicating which key matched
    wire [3:0] key_match;

    assign key_match[0] = (scancode == 16'hE06B); // left
    assign key_match[1] = (scancode == 16'hE072); // down
    assign key_match[2] = (scancode == 16'hE074); // right
    assign key_match[3] = (scancode == 16'hE075); // up

    // Directly map key_match bits to outputs
    assign left  = key_match[0];
    assign down  = key_match[1];
    assign right = key_match[2];
    assign up    = key_match[3];

endmodule