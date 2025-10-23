module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// State codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Internal state signal
reg [2:0] current_state;
reg [2:0] next_state;

// High output bit
reg high_output;

// Next state logic for low output states
wire next_state_low;
assign next_state_low = (current_state == A)? (w? B : A) :
                        (current_state == B)? (w? C : D) :
                        (current_state == C)? (w? E : D) :
                        (current_state == D)? (w? F : A) : A;

// Next state logic for high output states
wire next_state_high;
assign next_state_high = (current_state == E)? (w? E : D) :
                         (current_state == F)? (w? C : D) : A;

// Mux for next state
assign next_state = high_output? next_state_high : next_state_low;

// Update high output bit
always @(posedge clk)
begin
    if(reset)
        high_output <= 0;
    else if(current_state == E || current_state == F)
        high_output <= 1;
    else if(next_state == E || next_state == F)
        high_output <= 1;
    else
        high_output <= 0;
end

// State flip-flops
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// FSM output
assign z = high_output;

endmodule