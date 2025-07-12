module TopModule (
    input clk,
    input a,
    output reg [2:0] q = 3'b100
);

always @(posedge clk) begin
    if (!a) begin
        q <= (q == 3'b110) ? 3'b000 : q + 1;
    end
    // q maintains value when a=1 (no else needed)
end

endmodule