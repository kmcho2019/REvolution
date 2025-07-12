module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Using a 1-bit register to represent the state

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B, represented by binary '0'
        out <= 1; // Output is 1 in state B
    end else begin
        case(in)
            0: begin
                if(state == 0) state <= 1; // Transition from B to A
                else state <= 0; // Transition from A to B
            end
            1: begin
                if(state == 0) state <= 0; // Stay in B
                else state <= 1; // Stay in A
            end
        endcase
        out <= ~state; // Output is 1 in state B (0) and 0 in state A (1)
    end
end

endmodule