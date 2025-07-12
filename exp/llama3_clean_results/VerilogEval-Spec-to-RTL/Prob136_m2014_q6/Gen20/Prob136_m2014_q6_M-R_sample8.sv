module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using Gray code encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b011;
parameter D = 3'b010;
parameter E = 3'b110;
parameter F = 3'b111;

// Define the state register using Gray code encoding
reg [2:0] state;
reg [2:0] next_state;

// Combinational logic for next state using direct assignment
always @(*) begin
    case (state)
        A: next_state = w? A : B;
        B: next_state = w? D : C;
        C: next_state = w? D : E;
        D: next_state = w? A : F;
        E: next_state = w? D : E;
        F: next_state = w? D : C;
        default: next_state = A;
    endcase
end

// Alternatively, using assign for next state logic (simplified example, may not cover all states)
// assign next_state = (state == A && w)? A : (state == A && ~w)? B : 
//                     (state == B && w)? D : (state == B && ~w)? C : 
//                     (state == C && w)? D : (state == C && ~w)? E : 
//                     (state == D && w)? A : (state == D && ~w)? F : 
//                     (state == E && w)? D : (state == E && ~w)? E : 
//                     (state == F && w)? D : (state == F && ~w)? C : A;

// Combinational logic for output z
assign z = (state == E) || (state == F);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule