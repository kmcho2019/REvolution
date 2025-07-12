module TopModule(
    input  clk,
    input  areset,
    input  [7:0] d,
    output [7:0] q
);

reg [7:0] q;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 8'd0; // Reset q to 0
    end else begin
        q <= d; // Load d into q
    end
end

endmodule