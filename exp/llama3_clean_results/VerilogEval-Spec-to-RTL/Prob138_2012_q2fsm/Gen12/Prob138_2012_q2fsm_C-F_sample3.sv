module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// State codes using one-hot encoding for potential power and timing improvements
parameter A = 3'b001;
parameter B = 3'b010;
parameter C = 3'b100;
parameter D = 3'b000; // Using 000 to reduce switching activity in transitions
parameter E = 3'b011;
parameter F = 3'b101;

// Internal state signal
reg [2:0] current_state;
reg [2:0] next_state;

// State table using assign statements for conciseness and efficiency
assign next_state = (current_state == A)? (w? B : A) :
                    (current_state == B)? (w? C : D) :
                    (current_state == C)? (w? E : D) :
                    (current_state == D)? (w? F : A) :
                    (current_state == E)? (w? E : D) :
                    (current_state == F)? (w? C : D) :
                    A; // Default state

// State flip-flops with synchronized reset
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// FSM output using a continuous assignment for efficiency
assign z = (current_state == E || current_state == F);

endmodule