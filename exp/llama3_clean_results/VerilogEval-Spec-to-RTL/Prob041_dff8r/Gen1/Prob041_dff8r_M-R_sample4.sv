module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q // Declare q as reg to allow procedural assignment
);

always_ff @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;
    end else begin
        q <= d;
    end
end

endmodule