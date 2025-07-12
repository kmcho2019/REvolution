module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        // Shift in data to MSB, shift bits right
        q <= {data, q[3:1]};
    end else if (count_ena) begin
        // Decrement the current value, wrap-around naturally
        q <= q - 1'b1;
    end else begin
        // Hold the current value if neither enable is asserted
        q <= q;
    end
end

endmodule