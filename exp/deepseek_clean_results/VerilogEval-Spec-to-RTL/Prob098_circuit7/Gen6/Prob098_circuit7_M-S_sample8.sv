module TopModule (
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    q <= ~a;  // Directly assign inverted 'a' to q on clock edge
end

endmodule