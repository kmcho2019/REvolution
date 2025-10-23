module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state = 4'd1; // Initialize state to 1

always @(posedge clk) begin
    if (reset) begin
        state <= 4'd1; // Reset to 1
    end else begin
        if (state == 4'd10) begin
            state <= 4'd1; // Wrap around to 1
        end else begin
            state <= state + 4'd1; // Increment state
        end
    end
end

assign q = state;

endmodule