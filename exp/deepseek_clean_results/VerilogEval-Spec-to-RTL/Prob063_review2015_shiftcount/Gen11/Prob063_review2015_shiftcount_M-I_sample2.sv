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
        // Decrement operation using addition (more efficient in hardware)
        q <= q + 4'b1111;
    end
    // else: q remains unchanged (implicit clock gating)
end

endmodule