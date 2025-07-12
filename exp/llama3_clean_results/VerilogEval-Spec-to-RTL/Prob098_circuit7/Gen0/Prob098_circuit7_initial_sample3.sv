module TopModule (
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a == 0) begin
        q <= 1; // If a is 0, q remains or becomes 1
    end else begin
        q <= 0; // If a is 1, q becomes 0
    end
end

endmodule