module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_shift = {q[2:0], data};
wire [3:0] next_count = q - 1;
wire [3:0] next_both = {q[2:0], data} - 1; // Undefined case - arbitrary choice

always @(posedge clk) begin
    case ({shift_ena, count_ena})
        2'b00: q <= q;                   // Hold
        2'b10: q <= next_shift;           // Shift only
        2'b01: q <= next_count;           // Count only
        2'b11: q <= next_both;           // Both (undefined behavior)
    endcase
end

endmodule