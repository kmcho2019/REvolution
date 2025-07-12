module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Define rotation operations as wires for clarity
wire [99:0] rotate_left = {q[98:0], q[99]};
wire [99:0] rotate_right = {q[0], q[99:1]};

always @(posedge clk) begin
    if (load)
        q <= data;
    else case (ena)
        2'b01: q <= rotate_right;
        2'b10: q <= rotate_left;
        default: q <= q;
    endcase
end

endmodule