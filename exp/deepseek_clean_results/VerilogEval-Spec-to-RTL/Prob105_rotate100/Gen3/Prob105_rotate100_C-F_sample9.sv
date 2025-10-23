module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Parameterized width for maintainability (though fixed at 100 for this problem)
parameter WIDTH = 100;

always @(posedge clk) begin
    if (load) begin
        q <= data;  // Synchronous load
    end else begin
        case (ena)
            2'b01: q <= {q[0], q[WIDTH-1:1]};    // Right rotate: LSB moves to MSB
            2'b10: q <= {q[WIDTH-2:0], q[WIDTH-1]}; // Left rotate: MSB moves to LSB
            default: q <= q;  // No rotation - clock gating recommended here
        endcase
    end
end

endmodule