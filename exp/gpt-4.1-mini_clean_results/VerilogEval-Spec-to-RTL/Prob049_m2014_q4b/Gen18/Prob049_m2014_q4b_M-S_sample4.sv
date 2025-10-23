module TopModule (
    input  clk,
    input  ar,    // Asynchronous active-high reset
    input  d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar)
        q <= 1'b0;
    else
        q <= d;
end

endmodule