module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// One-hot encoded rotation controls
wire rotate_right = (ena == 2'b01);
wire rotate_left = (ena == 2'b10);
wire no_rotate = (ena == 2'b00) || (ena == 2'b11);

// Clock gating logic
wire clk_en = load || !no_rotate;
wire gated_clk;
assign gated_clk = clk & clk_en;

// Rotation amount (1 bit)
wire rotate_amount = 1'b1;

// Barrel shifter implementation
always @(posedge gated_clk) begin
    if (load) begin
        q <= data;
    end else begin
        case ({rotate_left, rotate_right})
            2'b01: q <= {q[0], q[99:1]};    // Right rotate
            2'b10: q <= {q[98:0], q[99]};    // Left rotate
            default: q <= q;                  // No rotation (clock gated)
        endcase
    end
end

endmodule