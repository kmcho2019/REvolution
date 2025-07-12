module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    case ({shift_ena, count_ena})
        2'b10: q <= {q[2:0], data};       // Shift left with new data
        2'b01: q <= {q[0], q[3:1]};      // Rotate right (count down)
        default: q <= q;                  // Hold value if neither or both
    endcase
end

endmodule