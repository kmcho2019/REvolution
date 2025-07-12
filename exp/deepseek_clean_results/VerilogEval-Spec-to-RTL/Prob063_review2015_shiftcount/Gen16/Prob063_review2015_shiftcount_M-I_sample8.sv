module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        q <= {q[2:0], data};        // Shift operation
    end
    else if (count_ena) begin
        q <= q + 4'b1111;           // Count operation (equivalent to q - 1)
    end
    // else maintain current value (implicit)
end

endmodule