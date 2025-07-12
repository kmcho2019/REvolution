module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit variable to hold the state (A=0, B=1)

// Combinational logic: Determine output
assign out = state; // Since out = 1 when state is B (1'b1) and out = 0 when state is A (1'b0)

// Sequential logic: Update state
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        case(state)
            1'b0: begin // State A
                if(in == 1'b0) begin
                    state <= 1'b1; // From A, in=0 -> B
                end else begin
                    state <= 1'b0; // From A, in=1 -> A
                end
            end
            1'b1: begin // State B
                if(in == 1'b0) begin
                    state <= 1'b0; // From B, in=0 -> A
                end else begin
                    state <= 1'b1; // From B, in=1 -> B
                end
            end
            default: begin
                state <= 1'bx; 
            end
        endcase
    end
end

endmodule