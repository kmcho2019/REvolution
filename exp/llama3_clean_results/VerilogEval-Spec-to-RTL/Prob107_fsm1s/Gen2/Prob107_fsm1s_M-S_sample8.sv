module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg state;

assign out = ~state; // Directly assign output based on state

always @(posedge clk) begin
    if(reset) begin
        state <= 1'b1; // Reset to state B (out=1)
    end else begin
        state <= in ? state : ~state; // Simplified state transition logic
    end
end

endmodule