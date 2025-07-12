module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena != 2'b00 && ena != 2'b11) begin  // Clock gating optimization
        case (ena)
            2'b01: q <= {q[0], q[99:1]};    // Right rotate
            2'b10: q <= {q[98:0], q[99]};   // Left rotate
        endcase
    end
    // Implicit else: q holds its value
end

endmodule