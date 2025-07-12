module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'd0; // synchronous reset
    end else begin
        q <= d; // load data on positive edge of clk
    end
end

endmodule