module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Using a single bit to represent the state

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B, represented by binary '0'
        out <= 1; // Output is 1 in state B
    end else begin
        case(state)
            1'b0: begin // Current state is B
                if(!in) begin
                    state <= 1; // Transition to A
                    out <= 0; // Output is 0 in state A
                end
            end
            1'b1: begin // Current state is A
                if(in) begin
                    // Stay in A, output remains 0
                end else begin
                    state <= 0; // Transition to B
                    out <= 1; // Output is 1 in state B
                end
            end
        endcase
    end
end

endmodule