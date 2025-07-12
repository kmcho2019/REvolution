module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Pre-compute all possible rotation outcomes
wire [99:0] right_rot = {q[0], q[99:1]};
wire [99:0] left_rot  = {q[98:0], q[99]};
wire [99:0] no_rot    = q;

// Combined control signal
wire [1:0] mux_sel = load ? 2'b11 : 
                    (ena == 2'b01) ? 2'b01 : 
                    (ena == 2'b10) ? 2'b10 : 2'b00;

always @(posedge clk) begin
    case (mux_sel)
        2'b00: q <= no_rot;     // No rotation
        2'b01: q <= right_rot;  // Right rotate
        2'b10: q <= left_rot;   // Left rotate
        2'b11: q <= data;       // Load
    endcase
end

endmodule