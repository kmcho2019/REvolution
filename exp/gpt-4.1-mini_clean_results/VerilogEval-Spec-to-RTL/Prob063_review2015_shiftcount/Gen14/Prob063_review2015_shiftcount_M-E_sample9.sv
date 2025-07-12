module TopModule (
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        // Shift left, shift in data at MSB
        q <= {data, q[3:1]};
    end else if (count_ena) begin
        // Decrement by 1 using built-in subtract operator
        q <= q - 4'd1;
    end else begin
        q <= q; // hold state
    end
end

endmodule