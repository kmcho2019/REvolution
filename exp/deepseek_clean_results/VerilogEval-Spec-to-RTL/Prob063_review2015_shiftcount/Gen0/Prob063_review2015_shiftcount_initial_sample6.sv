module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        // Shift operation (MSB first)
        q <= {q[2:0], data};
    end
    else if (count_ena) begin
        // Decrement operation
        q <= q - 1'b1;
    end
    // If neither is enabled, q retains its value
end

endmodule