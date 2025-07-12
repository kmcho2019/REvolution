module TopModule(
    input  clk,
    input  reset,
    input  [7:0] d,
    output reg [7:0] q
);

always @(negedge clk or posedge reset) begin
    if (reset) begin
        // Reset to the specific value 0x34
        q <= 8'b00110100;
    end else begin
        q <= d;
    end
end

endmodule