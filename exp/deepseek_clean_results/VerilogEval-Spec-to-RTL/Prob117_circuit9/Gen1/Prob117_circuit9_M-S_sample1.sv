module TopModule (
    input clk,
    input a,
    output reg [2:0] q = 3'd4  // initialize to 4
);

always @(posedge clk) begin
    q <= a ? q : (q + 1) % 7;  // hold or increment with wrap at 6
end

endmodule