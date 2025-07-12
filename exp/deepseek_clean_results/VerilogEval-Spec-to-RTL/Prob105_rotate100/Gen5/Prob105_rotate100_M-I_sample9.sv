module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire rotate_enable = (ena == 2'b01) || (ena == 2'b10);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (rotate_enable) begin
        casez (ena)
            2'b01: q <= {q[0], q[99:1]};    // Right rotate
            2'b10: q <= {q[98:0], q[99]};    // Left rotate
        endcase
    end
    // Implicit else maintains current value (no latch inferred)
end

endmodule