module TopModule(
    input  clk,
    input  ar,
    input  d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) q <= 1'b0; // Asynchronous reset takes precedence
    else if (posedge clk) q <= d; // Update on positive clock edge
end

endmodule