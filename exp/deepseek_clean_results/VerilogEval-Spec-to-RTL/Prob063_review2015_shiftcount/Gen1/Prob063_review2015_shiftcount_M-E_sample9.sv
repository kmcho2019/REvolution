module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_shift = {q[2:0], data};
wire [3:0] next_count = q + 4'b1111; // Equivalent to q - 1

always @(posedge clk) begin
    case ({shift_ena, count_ena})
        2'b10: q <= next_shift;    // Shift operation
        2'b01: q <= next_count;   // Count operation
        default: q <= q;          // Hold when neither or both
    endcase
end

endmodule