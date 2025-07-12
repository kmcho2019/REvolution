module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    case ({shift_ena, count_ena})
        2'b10: q <= {q[2:0], data};  // Shift operation (MSB first)
        2'b01: q <= q - 1'b1;       // Decrement operation
        default: ;                   // Hold value (implicit)
    endcase
end

endmodule