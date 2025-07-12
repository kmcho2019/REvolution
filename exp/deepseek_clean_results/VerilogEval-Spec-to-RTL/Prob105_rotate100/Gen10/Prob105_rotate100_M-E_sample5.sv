module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Pre-compute all possible rotation outcomes
wire [99:0] right_rot = {q[0], q[99:1]};    // Right rotate
wire [99:0] left_rot  = {q[98:0], q[99]};    // Left rotate
wire [99:0] no_change = q;                   // No rotation
wire [99:0] load_val  = data;                // Load value

// Combined control signal
wire [2:0] ctrl = {load, ena};

always @(posedge clk) begin
    case (ctrl)
        3'b1xx:  q <= load_val;   // Load has highest priority
        3'b001:  q <= right_rot;  // Right rotate
        3'b010:  q <= left_rot;   // Left rotate
        default: q <= no_change;  // Default case (including 3'b000, 3'b011, etc.)
    endcase
end

endmodule