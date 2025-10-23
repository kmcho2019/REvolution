module TopModule #(parameter WIDTH = 4) (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [WIDTH-1:0] q = 0  // Initialize to zero
);

always @(posedge clk) begin
    case ({shift_ena, count_ena})
        2'b10: q <= {q[WIDTH-2:0], data};  // Shift operation (MSB first)
        2'b01: q <= q - 1'b1;              // Count down operation
        default: q <= q;                   // Hold value (implicit clock gating)
    endcase
end

endmodule