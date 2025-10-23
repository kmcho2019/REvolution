module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] state;

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0
        state <= 4'd0;
    end else if (slowena) begin
        // Increment the state, wrapping around to 0 after 9
        state <= (state == 4'd9) ? 4'd0 : state + 1'd1;
    end
end

assign q = state;

endmodule