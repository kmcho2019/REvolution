module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_shift = {q[2:0], data};
wire [3:0] next_count = {q[3:1], ~q[0]} - {3'b0, q[0]};  // Optimized decrement

reg clk_en;
always @(*) begin
    clk_en = shift_ena | count_ena;  // Clock gating control
end

always @(posedge clk) begin
    if (clk_en) begin
        case ({shift_ena, count_ena})
            2'b10: q <= next_shift;    // Shift operation
            2'b01: q <= next_count;   // Count operation
            default: q <= q;           // Shouldn't occur per spec
        endcase
    end
    // Implicit else: clock gated, register holds value
end

endmodule