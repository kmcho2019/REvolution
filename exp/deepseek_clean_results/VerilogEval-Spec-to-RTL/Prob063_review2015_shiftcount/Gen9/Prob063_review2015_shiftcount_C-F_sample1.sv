module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena)
        q <= {q[2:0], data};  // Shift has priority
    else if (count_ena)
        q <= q - 1'b1;        // Decrement when count enabled
    // Implicit else: q holds value (optimized away in synthesis)
end

endmodule