module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit variable to hold the state (A=0, B=1)

always @(*) begin
    out = state; // Directly determine output based on state
end

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        if(state == 1'b0) begin // Current state is A
            if(in == 1'b0) begin
                state <= 1'b1; // From A, in=0 -> B
            end // else stay in A
        end else begin // Current state is B
            if(in == 1'b0) begin
                state <= 1'b0; // From B, in=0 -> A
            end // else stay in B
        end
    end
end

endmodule