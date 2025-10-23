module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using a combination of one-hot and binary encoding
parameter A = 4'b0001;
parameter B = 4'b0010;
parameter C = 4'b0100;
parameter D = 4'b1000;
parameter E = 4'b0000; // Using 0 for E to simplify the logic
parameter F = 4'b0011; // Using a different encoding for F to reduce area

// Define the state register using the combined encoding
reg [3:0] currentState;
reg [3:0] nextState;

// Combinational logic to determine the next state
always @(*) begin
    case (currentState)
        A: nextState = w? A : B;
        B: nextState = w? D : C;
        C: nextState = w? D : E;
        D: nextState = w? A : F;
        E: nextState = w? D : E;
        F: nextState = w? D : C;
        default: nextState = A;
    endcase
end

// Combinational logic for output z
assign z = (currentState == E) || (currentState == F);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) currentState <= A;
    else currentState <= nextState;
end

endmodule