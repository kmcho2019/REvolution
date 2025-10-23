module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define state codes
parameter STATE_A = 3'b000;
parameter STATE_B = 3'b001;
parameter STATE_C = 3'b010;
parameter STATE_D = 3'b011;
parameter STATE_E = 3'b100;
parameter STATE_F = 3'b101;

// Declare current state and next state
reg [2:0] currentState, nextState;

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        currentState <= STATE_A;
    end else begin
        currentState <= nextState;
    end
end

// Next state logic
always @(*) begin
    case (currentState)
        STATE_A: nextState = (w) ? STATE_B : STATE_A;
        STATE_B: nextState = (w) ? STATE_C : STATE_D;
        STATE_C: nextState = (w) ? STATE_E : STATE_D;
        STATE_D: nextState = (w) ? STATE_F : STATE_A;
        STATE_E: nextState = (w) ? STATE_E : STATE_D;
        STATE_F: nextState = (w) ? STATE_C : STATE_D;
        default: nextState = STATE_A;
    endcase
end

// Output logic
assign z = (currentState == STATE_E || currentState == STATE_F) ? 1'b1 : 1'b0;

endmodule