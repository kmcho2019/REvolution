module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] currentState, nextState;
assign Y0 = nextState[0];

// Determine the output z based on the current state and next state
always @(*) begin
    case (currentState)
        3'b000: z = 0;
        3'b001: z = 0;
        3'b010: z = 0;
        3'b011: z = 1;
        3'b100: z = 1;
        default: z = 0; // default case for other states (if any)
    endcase
end

// Determine the next state based on the current state and inputs x and y
always @(*) begin
    case (currentState)
        3'b000: if (!x) nextState = 3'b000; else nextState = 3'b001;
        3'b001: if (!x) nextState = 3'b001; else nextState = 3'b100;
        3'b010: if (!x) nextState = 3'b010; else nextState = 3'b001;
        3'b011: if (!x) nextState = 3'b001; else nextState = 3'b010;
        3'b100: if (!x) nextState = 3'b011; else nextState = 3'b100;
        default: nextState = 3'b000; // default case for other states (if any)
    endcase
end

// Update the current state on the rising edge of the clock
always @(posedge clk) begin
    currentState <= nextState;
end

// Initialize the current state to a default value
initial begin
    currentState <= 3'b000;
end

endmodule