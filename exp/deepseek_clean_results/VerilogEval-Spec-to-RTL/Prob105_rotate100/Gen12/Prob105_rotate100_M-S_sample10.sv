module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

always @(posedge clk) begin
    if (load) q <= data;
    else begin
        case (ena)
            2'b01: q <= {q[0], q[99:1]};  // right rotate
            2'b10: q <= {q[98:0], q[99]};  // left rotate
            default: q <= q;              // no change
        endcase
    end
end

endmodule