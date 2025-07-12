module TopModule (
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    // q is the inverted value of a, sampled at clock edge
    q <= ~a;
end

endmodule