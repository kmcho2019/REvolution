module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    // Combinational logic for decoding scancode to arrow keys
    reg l, d, r, u;
    always @(*) begin
        l = 0;
        d = 0;
        r = 0;
        u = 0;
        case (scancode)
            16'hE06B: l = 1'b1; // left arrow
            16'hE072: d = 1'b1; // down arrow
            16'hE074: r = 1'b1; // right arrow
            16'hE075: u = 1'b1; // up arrow
            default: begin
                l = 0; d = 0; r = 0; u = 0;
            end
        endcase
    end

    assign left  = l;
    assign down  = d;
    assign right = r;
    assign up    = u;

endmodule