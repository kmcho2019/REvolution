module TopModule(
    input  clk,
    input  ar,
    input  d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        // Reset condition has the highest priority
        q <= 1'b0;
    end else if (posedge clk) begin
        // On positive clock edge, if not in reset, assign d to q
        q <= d;
    end
end

endmodule