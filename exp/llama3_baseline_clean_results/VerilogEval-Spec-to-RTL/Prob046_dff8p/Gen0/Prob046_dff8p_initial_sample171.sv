module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q;

always_ff @(negedge clk) begin
    if (reset) begin
        q <= 8'h34; // reset to 0x34
    end else begin
        q <= d;
    end
end

endmodule