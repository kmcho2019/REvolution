module TopModule (
    input clk,
    input reset,
    input enable,    // Added enable signal for power optimization
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;
    end
    else if (enable) begin
        q <= d;
    end
end

endmodule