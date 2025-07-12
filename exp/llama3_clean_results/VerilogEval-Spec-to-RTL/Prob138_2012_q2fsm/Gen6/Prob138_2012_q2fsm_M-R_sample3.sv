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

// State table
assign next_state = 
    (current_state == A && w) ? B :
    (current_state == A && !w) ? A :
    (current_state == B && w) ? C :
    (current_state == B && !w) ? D :
    (current_state == C && w) ? E :
    (current_state == C && !w) ? D :
    (current_state == D && w) ? F :
    (current_state == D && !w) ? A :
    (current_state == E && w) ? E :
    (current_state == E && !w) ? D :
    (current_state == F && w) ? C :
    (current_state == F && !w) ? D :
    A;

// State flip-flops
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// FSM output
assign z = (current_state == E) || (current_state == F);

endmodule