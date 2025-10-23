module TopModule(
    input  clk,
    input  reset,
    input  w,
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

// State table using assign statements with reduced conditional checks
assign next_state = (current_state == A || current_state == B || current_state == C || current_state == D) ? 
                    (w ? (current_state == A ? B : (current_state == B ? C : (current_state == C ? E : F))) : 
                     (current_state == A ? A : (current_state == B ? D : (current_state == C ? D : (current_state == D ? A : D))))) : 
                    (current_state == E || current_state == F) ? 
                    (w ? (current_state == E ? E : C) : D) : A; // Default state

// State flip-flops
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Output z
assign z = (current_state == E || current_state == F);

endmodule