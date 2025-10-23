module TopModule(
    input  clk,
    input  ar,
    input  d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0; // Asynchronous reset takes precedence
    end else if (posedge clk) begin // Ensure d is captured on positive edge of clk
        q <= d;
    end
end

endmodule