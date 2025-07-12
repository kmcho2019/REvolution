module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg state;
assign out = ~state;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state B (0)
    end else begin
        state <= (state == 0 && in == 0) ? 1 : (state == 0 && in == 1) ? 0 : (state == 1 && in == 0) ? 0 : 1;
    end
end

endmodule