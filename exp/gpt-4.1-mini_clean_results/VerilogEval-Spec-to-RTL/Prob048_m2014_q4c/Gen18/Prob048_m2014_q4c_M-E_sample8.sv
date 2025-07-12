module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);

reg q_int;

always @(posedge clk) begin
    if (r)
        q_int <= 1'b0;  // synchronous reset logic
    else
        q_int <= d;     // capture data
end

always @(posedge clk) begin
    q <= q_int;         // update output register
end

endmodule