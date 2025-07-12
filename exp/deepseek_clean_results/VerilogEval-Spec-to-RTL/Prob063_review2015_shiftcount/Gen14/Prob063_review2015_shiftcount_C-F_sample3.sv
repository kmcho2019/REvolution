module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        q <= {q[2:0], data};  // Shift operation takes priority
    end
    else begin
        q <= q - count_ena;   // Efficient count: only subtract when count_ena=1
    end
end

endmodule