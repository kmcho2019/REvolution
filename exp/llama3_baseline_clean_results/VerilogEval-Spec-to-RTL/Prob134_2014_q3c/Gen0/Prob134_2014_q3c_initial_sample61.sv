module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] currentState, nextState;

// Initialize the state
initial currentState = 3'b000;

// Combinational logic to determine next state and output
always @(*) begin
    case(currentState)
        3'b000: begin
            if (!x) nextState = 3'b000;
            else    nextState = 3'b001;
            z = 1'b0;
        end
        3'b001: begin
            if (!x) nextState = 3'b001;
            else    nextState = 3'b100;
            z = 1'b0;
        end
        3'b010: begin
            if (!x) nextState = 3'b010;
            else    nextState = 3'b001;
            z = 1'b0;
        end
        3'b011: begin
            if (!x) nextState = 3'b001;
            else    nextState = 3'b010;
            z = 1'b1;
        end
        3'b100: begin
            if (!x) nextState = 3'b011;
            else    nextState = 3'b100;
            z = 1'b1;
        end
        default: begin
            nextState = 3'b000;
            z = 1'b0; // Default output for unspecified states
        end
    endcase
    Y0 = nextState[0]; // Output Y0 is the least significant bit of nextState
end

// Sequential logic to update the state on the rising edge of the clock
always @(posedge clk) begin
    currentState <= nextState;
end

endmodule