module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// One-hot encoding for state A (1) and state B (0)
reg state;

// State transition logic
always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Asynchronous reset to state A
        state <= 1'b1;
    end else begin
        // Synchronous state transitions
        case(state)
            1'b1: state <= x? 1'b0 : 1'b1; // Transition from A to B or stay in A
            1'b0: state <= 1'b0; // Stay in B
        endcase
    end
end

// Combinational logic for z using assign
assign z = (state)? x : ~x;

endmodule