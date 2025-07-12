module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// State register
reg [2:0] currentState;

// Define states directly with gray code encoding
localparam A = 3'b000, B = 3'b001, C = 3'b011, D = 3'b010, E = 3'b110, F = 3'b111;

// Combinational logic for next state and output using assign
reg [2:0] nextState;
assign nextState = 
    (currentState == A)  ? (w ? A  : B)  :
    (currentState == B)  ? (w ? D  : C)  :
    (currentState == C)  ? (w ? D  : E)  :
    (currentState == D)  ? (w ? A  : F)  :
    (currentState == E)  ? (w ? D  : E)  :
    (currentState == F)  ? (w ? D  : C)  :
    A; // Default state

assign z = (currentState == E) || (currentState == F);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) currentState <= A;
    else currentState <= nextState;
end

endmodule