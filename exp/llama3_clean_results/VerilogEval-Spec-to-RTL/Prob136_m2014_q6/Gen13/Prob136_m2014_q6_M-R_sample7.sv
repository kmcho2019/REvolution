module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using binary encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define the state register using binary encoding
reg [2:0] currentState;
reg [2:0] nextState;

// Combinational logic to determine the next state
always @(*) begin
    case (currentState)
        A: nextState = w ? A : B;
        B: nextState = w ? D : C;
        C: nextState = w ? D : E;
        D: nextState = w ? A : F;
        E: nextState = w ? D : E;
        F: nextState = w ? D : C;
        default: nextState = A;
    endcase
end

// Output z logic
assign z = (currentState == E) || (currentState == F);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) currentState <= A;
    else currentState <= nextState;
end

endmodule