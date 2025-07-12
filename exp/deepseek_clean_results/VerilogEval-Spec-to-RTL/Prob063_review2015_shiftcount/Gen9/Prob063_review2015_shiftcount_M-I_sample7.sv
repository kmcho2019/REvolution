module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire clk_enable = shift_ena | count_ena;
reg [3:0] next_q;

always @(*) begin
    if (shift_ena)
        next_q = {q[2:0], data};  // Shift operation
    else if (count_ena)
        next_q = q - 1'b1;        // Count operation
    else
        next_q = q;               // Hold value
end

always @(posedge clk) begin
    if (clk_enable)
        q <= next_q;
    // else retain value (implicit clock gating)
end

endmodule