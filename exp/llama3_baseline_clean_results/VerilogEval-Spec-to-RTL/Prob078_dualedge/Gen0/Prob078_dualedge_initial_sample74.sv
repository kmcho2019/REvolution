module TopModule (
    input clk,
    input d,
    output reg q
);

reg q_pos, q_neg;

always @(posedge clk) begin
    q_pos <= d;
end

always @(posedge ~clk) begin
    q_neg <= d;
end

always @(posedge clk) begin
    if (~clk == 1'b0)
        q <= q_pos;
    else
        q <= q_neg;
end

// Alternatively, you can use the following simpler implementation:
// always @(posedge clk or negedge clk) begin
//     q <= d;
// end

// But since this isn't synthesizable, we use:
always @(posedge clk) begin
    q <= d;
end

always @(negedge clk) begin
    q <= d;
end

endmodule