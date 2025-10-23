module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] currentState;
reg [2:0] nextState;

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        currentState <= 3'b000; // Reset to state A
    end else begin
        currentState <= nextState;
    end
end

// State table
always @(*) begin
    case (currentState)
        3'b000: begin // State A
            if (w) begin
                nextState = 3'b001; // Transition to state B
            end else begin
                nextState = 3'b000; // Stay in state A
            end
        end
        3'b001: begin // State B
            if (w) begin
                nextState = 3'b010; // Transition to state C
            end else begin
                nextState = 3'b011; // Transition to state D
            end
        end
        3'b010: begin // State C
            if (w) begin
                nextState = 3'b100; // Transition to state E
            end else begin
                nextState = 3'b011; // Transition to state D
            end
        end
        3'b011: begin // State D
            if (w) begin
                nextState = 3'b101; // Transition to state F
            end else begin
                nextState = 3'b000; // Transition to state A
            end
        end
        3'b100: begin // State E
            if (w) begin
                nextState = 3'b100; // Stay in state E
            end else begin
                nextState = 3'b011; // Transition to state D
            end
        end
        3'b101: begin // State F
            if (w) begin
                nextState = 3'b010; // Transition to state C
            end else begin
                nextState = 3'b011; // Transition to state D
            end
        end
    endcase
end

// Output z based on current state
assign z = (currentState == 3'b100 && w) || (currentState == 3'b101 && w);

endmodule