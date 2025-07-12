module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire clk_enable = shift_ena | count_ena;

always @(posedge clk) begin
    if (clk_enable) begin
        if (shift_ena)
            q <= {q[2:0], data};
        else // count_ena must be true if we get here
            q <= q - 1'b1;
    end
    // else q remains unchanged (implicit through clock gating)
end

endmodule