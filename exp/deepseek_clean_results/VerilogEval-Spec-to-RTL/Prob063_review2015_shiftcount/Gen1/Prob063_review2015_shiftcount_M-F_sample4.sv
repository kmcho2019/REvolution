module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        // Corrected shift operation: MSB first (left shift)
        q <= {q[2:0], data};
    end
    else if (count_ena) begin
        // Decrement operation remains the same
        q <= q - 1'b1;
    end
    // If neither is enabled, q retains its value
end

endmodule