module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire do_rotate_left = (ena == 2'b10);
wire do_rotate_right = (ena == 2'b01);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        case ({do_rotate_left, do_rotate_right})
            2'b10: q <= {q[98:0], q[99]};    // Left rotate
            2'b01: q <= {q[0], q[99:1]};      // Right rotate
            default: q <= q;                   // No rotate
        endcase
    end
end

endmodule