module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_shift = {q[2:0], data};
wire [3:0] next_count = {q[3]^(&q[2:0]), q[2]^(&q[1:0]), q[1]^q[0], ~q[0]};

always @(posedge clk) begin
    case ({shift_ena, count_ena})
        2'b10: q <= next_shift;       // Shift operation
        2'b01: q <= next_count;       // Count operation using XOR logic
        default: q <= q;              // Hold state
    endcase
end

endmodule