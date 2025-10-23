module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 8'b0;
    end else begin
        q <= d;
    end
end

endmodule