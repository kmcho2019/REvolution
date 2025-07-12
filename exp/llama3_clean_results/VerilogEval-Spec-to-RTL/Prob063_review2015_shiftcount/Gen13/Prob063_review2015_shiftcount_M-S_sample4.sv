module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q = 4'b0
);

always @(posedge clk) begin
    if (shift_ena) begin
        q <= {data, q[3:1]};
    end else if (count_ena) begin
        q <= (q == 4'b0)? 4'b0 : q - 1;  // Decrement or stay at 0
    end
end

endmodule