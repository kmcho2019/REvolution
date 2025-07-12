module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg state;
assign out = ~state;

always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0; // Synchronous reset to state B
    end else begin
        if(state == 1'b0) begin // State B
            state <= in ? 1'b0 : 1'b1;
        end else begin // State A
            state <= in ? 1'b1 : 1'b0;
        end
    end
end

endmodule