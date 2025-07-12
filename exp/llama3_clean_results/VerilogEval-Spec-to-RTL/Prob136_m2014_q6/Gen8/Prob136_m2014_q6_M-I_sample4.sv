module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states using one-hot encoding
reg [5:0] currentState;
reg [5:0] nextState;

// Output z is 1 when the state machine is in state E or F
assign z = currentState[4] || currentState[5];

// State transition logic using one-hot encoding
always_comb begin
    case (currentState)
        6'b000001: nextState = w? 6'b000001 : 6'b000010;
        6'b000010: nextState = w? 6'b000011 : 6'b000100;
        6'b000100: nextState = w? 6'b000011 : 6'b001000;
        6'b000011: nextState = w? 6'b000001 : 6'b010000;
        6'b001000: nextState = w? 6'b000011 : 6'b001000;
        6'b010000: nextState = w? 6'b000011 : 6'b000100;
        default: nextState = 6'b000001;
    endcase
end

// Clock gating to minimize unnecessary transitions
always_ff @(posedge clk) begin
    if (reset) begin
        currentState <= 6'b000001;
    end else begin
        currentState <= nextState;
    end
end

endmodule