module TopModule (
    input clk,
    input rst,          // synchronous reset (active high)
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (rst) begin
        q <= 4'd0;
    end else if (shift_ena) begin
        q <= {data, q[3:1]};
    end else if (count_ena) begin
        q <= q - 4'd1;
    end
    // else retain q
end

endmodule