module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena)
        q <= {q[2:0], data};  // Shift operation takes priority (arbitrary choice)
    else if (count_ena)
        q <= q - 1'b1;         // Count operation when enabled
    // No else case needed as per problem statement
end

endmodule