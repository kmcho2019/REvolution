module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Pre-decode control signals
wire do_load = load;
wire do_left = (ena == 2'b10);
wire do_right = (ena == 2'b01);

// Barrel rotation logic
wire [99:0] rotated_left = {q[98:0], q[99]};
wire [99:0] rotated_right = {q[0], q[99:1]};

always @(posedge clk) begin
    case ({do_load, do_left, do_right})
        3'b100: q <= data;           // Load
        3'b010: q <= rotated_left;    // Rotate left
        3'b001: q <= rotated_right;   // Rotate right
        default: q <= q;             // Hold (includes 3'b000 case)
    endcase
end

endmodule