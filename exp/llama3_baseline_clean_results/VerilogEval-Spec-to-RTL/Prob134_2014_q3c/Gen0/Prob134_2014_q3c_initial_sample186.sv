module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] currentState, nextState;

// Output logic for z based on the current state and input x
always @(currentState, x) begin
    case(currentState)
        3'b000: z = 0;
        3'b001: z = 0;
        3'b010: z = 0;
        3'b011: z = 1;
        3'b100: z = 1;
        default: z = 0; // For any other state, set z to 0 by default
    endcase
end

// Next state logic
always @(currentState, x) begin
    case(currentState)
        3'b000: begin
            if (!x) nextState = 3'b000;
            else    nextState = 3'b001;
        end
        3'b001: begin
            if (!x) nextState = 3'b001;
            else    nextState = 3'b100;
        end
        3'b010: begin
            if (!x) nextState = 3'b010;
            else    nextState = 3'b001;
        end
        3'b011: begin
            if (!x) nextState = 3'b001;
            else    nextState = 3'b010;
        end
        3'b100: begin
            if (!x) nextState = 3'b011;
            else    nextState = 3'b100;
        end
        default: nextState = 3'b000; // Reset to 000 for any other state
    endcase
end

// Flip-flop to update the current state on the clock edge
always @(posedge clk) begin
    currentState <= nextState;
end

// Output Y0 is the least significant bit of the next state
assign Y0 = nextState[0];

endmodule