module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

wire prefix_ok = (scancode[15:8] == 8'he0);
wire [7:0] keycode = scancode[7:0];

reg l, d, r, u;

always @(*) begin
    l = 1'b0;
    d = 1'b0;
    r = 1'b0;
    u = 1'b0;
    if (prefix_ok) begin
        case (keycode)
            8'h6b: l = 1'b1;
            8'h72: d = 1'b1;
            8'h74: r = 1'b1;
            8'h75: u = 1'b1;
            default: ; // all outputs remain 0
        endcase
    end
end

assign left  = l;
assign down  = d;
assign right = r;
assign up    = u;

endmodule