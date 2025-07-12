// Define the states as an enumeration
`define STATE_A 2'b00
`define STATE_B 2'b01
`define STATE_C 2'b10
`define STATE_D 2'b11

module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [1:0] currentState;
reg [1:0] nextState;

// Assign output based on the current state
assign out = (currentState == `STATE_D) ? 1'b1 : 1'b0;

// Combinational logic for next state
always @(*) begin
    case(currentState)
        `STATE_A: nextState = (in == 1'b0) ? `STATE_A : `STATE_B;
        `STATE_B: nextState = (in == 1'b0) ? `STATE_C : `STATE_B;
        `STATE_C: nextState = (in == 1'b0) ? `STATE_A : `STATE_D;
        `STATE_D: nextState = (in == 1'b0) ? `STATE_C : `STATE_B;
        default: nextState = `STATE_A; // default to state A
    endcase
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        currentState <= `STATE_A;
    end else begin
        currentState <= nextState;
    end
end

endmodule