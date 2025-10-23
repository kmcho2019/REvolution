module TopModule (
    input clk,
    input a,
    output reg [2:0] q = 3'd4  // Initialize to 4
);

always @(posedge clk) begin
    q <= a ? 3'd4 : (q + 1) % 7;  // Set to 4 or increment with wrap-around
end

endmodule