module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        // Shift operation takes priority when both enables are active
        q <= {q[2:0], data};
    end
    else if (count_ena) begin
        // Down counter operation
        q <= q - 1'b1;
    end
    else begin
        // Hold value when neither is active (explicit for clarity)
        q <= q;
    end
end

endmodule