module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    case ({shift_ena, count_ena})
        2'b10: q <= {q[2:0], data};  // Shift operation
        2'b01: begin                 // Decrement operation
            q[0] <= ~q[0];
            q[1] <= q[1] ^ (~q[0]);
            q[2] <= q[2] ^ (&q[1:0]);
            q[3] <= q[3] ^ (&q[2:0]);
        end
        default: q <= q;             // Explicit hold state
    endcase
end

endmodule