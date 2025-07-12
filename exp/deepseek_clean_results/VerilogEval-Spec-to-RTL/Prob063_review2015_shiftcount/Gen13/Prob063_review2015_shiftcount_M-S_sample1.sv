module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        q <= {q[2:0], data};  // Shift operation
    end
    else if (count_ena) begin
        q <= q - 1'b1;        // Simple decrement when count_ena is 1
    end
    // Implicit else: q holds its value
end

endmodule