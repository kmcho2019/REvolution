module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q;

always @ (posedge clk) begin
    if (reset) begin
        q <= 8'd0; // synchronous reset
    end else begin
        q <= d; // assign d to q on positive edge of clk
    end
end

endmodule