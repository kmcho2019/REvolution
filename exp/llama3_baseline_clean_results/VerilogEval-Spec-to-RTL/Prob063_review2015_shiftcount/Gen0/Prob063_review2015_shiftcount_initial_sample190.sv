module TopModule(
    input  clk,
    input  shift_ena,
    input  count_ena,
    input  data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        // Shift data in most-significant-bit first
        q <= {data, q[3:1]};
    end else if (count_ena) begin
        // Decrement the number in the shift register
        if (q == 0) begin
            q <= 0; // Do not go below 0
        end else begin
            q <= q - 1;
        end
    end
end

endmodule