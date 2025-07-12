module TopModule(
    input  clk,
    input  ar,
    input  d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0; // Asynchronous reset
    end else if (clk) begin
        q <= d; // Capture input d on positive edge of clk
    end
end

endmodule