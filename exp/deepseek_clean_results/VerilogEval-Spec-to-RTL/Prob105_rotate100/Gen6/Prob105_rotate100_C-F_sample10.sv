module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Explicit rotation control signals
wire rotate_right = (ena == 2'b01);
wire rotate_left  = (ena == 2'b10);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        case ({rotate_left, rotate_right})
            2'b01: q <= {q[0], q[99:1]};    // Right rotate
            2'b10: q <= {q[98:0], q[99]};   // Left rotate
            default: q <= q;                 // No rotation
        endcase
    end
end

endmodule