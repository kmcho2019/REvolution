module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;  // Synchronous clear
    end else begin
        // Parallel load implementation
        shift_reg <= d;
    end
end

assign q = shift_reg;

endmodule