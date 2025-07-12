module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Shift register for scancode tracking
    reg [15:0] prev_scancode;
    wire new_scancode = (scancode != prev_scancode);

    always @(*) begin
        prev_scancode = scancode;
    end

    // Only decode when we have a new complete scancode
    wire valid_arrow = new_scancode && (scancode[15:8] == 8'hE0);

    // Parallel key decoding
    assign left  = valid_arrow && (scancode[7:0] == 8'h6B);
    assign down  = valid_arrow && (scancode[7:0] == 8'h72);
    assign right = valid_arrow && (scancode[7:0] == 8'h74);
    assign up    = valid_arrow && (scancode[7:0] == 8'h75);

endmodule