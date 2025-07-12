module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] internal_q = 8'b0; // Initialize internal_q to 0 for clarity

always @(posedge clk) begin
    if (reset) begin
        internal_q <= 8'b0;
    end else begin
        internal_q <= d;
    end
end

assign q = internal_q;

endmodule