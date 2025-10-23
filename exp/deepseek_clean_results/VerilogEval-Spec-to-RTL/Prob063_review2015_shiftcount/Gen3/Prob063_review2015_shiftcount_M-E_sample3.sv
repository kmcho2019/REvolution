module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_shift = {data, q[3:1]};  // Circular shift right with new MSB
wire [3:0] next_count = ~q + 1'b1;       // 2's complement trick for decrement

always @(posedge clk) begin
    case ({shift_ena, count_ena})
        2'b10: q <= next_shift;          // Shift mode
        2'b01: q <= next_count;          // Count mode
        default: q <= q;                 // Hold state
    endcase
end

endmodule