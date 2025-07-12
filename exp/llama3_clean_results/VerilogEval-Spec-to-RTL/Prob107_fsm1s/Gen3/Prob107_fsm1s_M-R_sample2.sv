module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit variable to hold the state (0 or 1)

// Sequential logic for state transitions and output assignment
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
        out <= 1'b1;
    end else begin
        case(state)
            1'b0: begin
                state <= (in == 1'b0)? 1'b1 : 1'b0;
                out <= (in == 1'b0)? 1'b1 : 1'b0;
            end
            1'b1: begin
                state <= (in == 1'b0)? 1'b0 : 1'b1;
                out <= (in == 1'b0)? 1'b0 : 1'b1;
            end
        endcase
    end
end

endmodule