module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define the states
logic [2:0] currentState;
logic [2:0] nextState;

// Output z is 1 when the state machine is in state E or F
assign z = (currentState == 3'b100) || (currentState == 3'b101);

// Calculate next state
always_comb begin
    case (currentState)
        3'b000: nextState = w? 3'b000 : 3'b001;
        3'b001: nextState = w? 3'b011 : 3'b010;
        3'b010: nextState = w? 3'b011 : 3'b100;
        3'b011: nextState = w? 3'b000 : 3'b101;
        3'b100: nextState = w? 3'b011 : 3'b100;
        3'b101: nextState = w? 3'b011 : 3'b010;
        default: nextState = 3'b000;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        currentState <= 3'b000;
    end else begin
        currentState <= nextState;
    end
end

endmodule