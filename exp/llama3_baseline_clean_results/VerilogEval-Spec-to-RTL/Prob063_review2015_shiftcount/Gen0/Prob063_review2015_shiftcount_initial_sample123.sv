module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (count_ena) begin
        if (q == 0) begin
            q <= 0; // Don't go below 0
        end else begin
            q <= q - 1;
        end
    end else if (shift_ena) begin
        q <= {q[2:0], data}; // Shift in the new data bit
    end
end

endmodule