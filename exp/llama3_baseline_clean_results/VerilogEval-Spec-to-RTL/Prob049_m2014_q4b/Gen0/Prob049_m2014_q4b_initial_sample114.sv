module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0; // Reset the flip flop to 0
    end else if (posedge clk) begin
        q <= d; // On the rising edge of clk, assign d to q
    end
end

endmodule