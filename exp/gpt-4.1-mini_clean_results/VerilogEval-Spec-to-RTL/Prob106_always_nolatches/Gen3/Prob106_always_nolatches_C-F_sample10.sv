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
    if (prefix_ok) begin
        case (keycode)
            8'h6b: begin l=1'b1; d=1'b0; r=1'b0; u=1'b0; end
            8'h72: begin l=1'b0; d=1'b1; r=1'b0; u=1'b0; end
            8'h74: begin l=1'b0; d=1'b0; r=1'b1; u=1'b0; end
            8'h75: begin l=1'b0; d=1'b0; r=1'b0; u=1'b1; end
            default: begin l=1'b0; d=1'b0; r=1'b0; u=1'b0; end
        endcase
    end else begin
        l=1'b0; d=1'b0; r=1'b0; u=1'b0;
    end
end

assign left  = l;
assign down  = d;
assign right = r;
assign up    = u;

endmodule