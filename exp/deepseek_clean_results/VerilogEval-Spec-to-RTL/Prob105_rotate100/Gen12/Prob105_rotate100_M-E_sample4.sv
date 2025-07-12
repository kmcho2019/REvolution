module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Calculate effective shift amount (signed)
wire signed [7:0] shift = (ena == 2'b01) ? -1 : 
                         (ena == 2'b10) ? 1 : 0;

// Barrel rotation implementation
wire [99:0] rotated;
assign rotated = (shift == 0) ? q :
                (shift == 1) ? {q[98:0], q[99]} :
                {q[0], q[99:1]};  // shift == -1

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena != 2'b00 && ena != 2'b11) begin
        q <= rotated;
    end
    // else q maintains its value (implicit)
end

endmodule