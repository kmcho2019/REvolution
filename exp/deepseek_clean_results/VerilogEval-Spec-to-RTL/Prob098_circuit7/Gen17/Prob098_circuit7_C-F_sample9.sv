module TopModule (
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    q <= ~a;  // Inversion and flip-flop in one clean operation
end

endmodule