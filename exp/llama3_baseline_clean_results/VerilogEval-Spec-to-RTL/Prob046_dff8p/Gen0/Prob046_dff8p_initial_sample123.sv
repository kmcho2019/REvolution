module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q;

always @ (negedge clk or posedge reset) begin
    if (reset) begin
        q <= 8'd52; // 52 is the decimal equivalent of 0x34
    end else begin
        q <= d;
    end
end

endmodule