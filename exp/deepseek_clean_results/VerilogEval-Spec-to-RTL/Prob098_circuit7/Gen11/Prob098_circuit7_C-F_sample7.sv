module TopModule (
    input clk,
    input a,
    output reg q
);

// q outputs the inverted value of a from previous clock cycle
always @(posedge clk) begin
    q <= ~a;
end

endmodule