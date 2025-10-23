module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        // Shift data in when shift_ena is 1
        q <= {data, q[3:1]};
    end else if (count_ena) begin
        // Decrement the count when count_ena is 1
        q <= q - 1;
    end
end

endmodule