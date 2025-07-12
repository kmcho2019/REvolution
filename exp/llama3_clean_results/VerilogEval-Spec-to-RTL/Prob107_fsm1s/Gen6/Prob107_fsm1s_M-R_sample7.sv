module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit variable to hold the state (0 or 1)

// Sequential and Combinational logic combined
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state 1
        out <= 1'b1; // Output reflects the reset state
    end else begin
        if(state == 1'b0) begin
            if(in == 1'b0) begin
                state <= 1'b1;
                out <= 1'b1;
            end else begin
                state <= 1'b0;
                out <= 1'b0;
            end
        end else begin // state == 1'b1
            if(in == 1'b0) begin
                state <= 1'b0;
                out <= 1'b0;
            end else begin
                state <= 1'b1;
                out <= 1'b1;
            end
        end
    end
end

endmodule