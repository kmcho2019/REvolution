module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        q <= {q[2:0], data};  // Shift operation (MSB first)
    end
    else if (count_ena) begin
        q <= q - 1'b1;        // Count operation (decrement)
    end
    else begin
        q <= q;               // Explicit hold state
    end
end

endmodule