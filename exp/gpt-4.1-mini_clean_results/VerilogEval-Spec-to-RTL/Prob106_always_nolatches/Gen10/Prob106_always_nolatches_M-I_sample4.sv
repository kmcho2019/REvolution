module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    wire [3:0] decoded;

    // Use case statement on the full 16-bit scancode
    // Mapping arrow keys to one-hot encoded bits: left=bit0, down=bit1, right=bit2, up=bit3
    assign decoded = (scancode == 16'he06b) ? 4'b0001 :
                     (scancode == 16'he072) ? 4'b0010 :
                     (scancode == 16'he074) ? 4'b0100 :
                     (scancode == 16'he075) ? 4'b1000 :
                     4'b0000;

    // Assign outputs from decoded bits
    assign left  = decoded[0];
    assign down  = decoded[1];
    assign right = decoded[2];
    assign up    = decoded[3];

endmodule