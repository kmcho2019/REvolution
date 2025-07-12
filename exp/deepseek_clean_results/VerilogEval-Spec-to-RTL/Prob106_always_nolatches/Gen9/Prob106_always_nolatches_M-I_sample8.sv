module TopModule (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

    // PS/2 scancode decoding for arrow keys
    // Extended keys have 0xE0 prefix followed by key code
    // Only update outputs when a valid extended key is detected
    always @(*) begin
        // Initialize outputs only when needed
        if (scancode[15:8] == 8'hE0) begin
            left = (scancode[7:0] == 8'h6B);
            down = (scancode[7:0] == 8'h72);
            right = (scancode[7:0] == 8'h74);
            up = (scancode[7:0] == 8'h75);
        end else begin
            left = 1'b0;
            down = 1'b0;
            right = 1'b0;
            up = 1'b0;
        end
    end

endmodule