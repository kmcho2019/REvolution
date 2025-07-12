module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define the states
parameter A = 4'd0;
parameter B = 4'd1;
parameter C = 4'd2;
parameter D = 4'd3;
parameter E = 4'd4;
parameter F = 4'd5;

reg [3:0] current_state;
reg [3:0] next_state;

// Combinational logic for state transition
always @(*)
begin
    case(current_state)
        A: next_state = (w)? B : A;
        B: next_state = (w)? C : D;
        C: next_state = (w)? E : D;
        D: next_state = (w)? F : A;
        E: next_state = (w)? E : D;
        F: next_state = (w)? C : D;
        default: next_state = A;
    endcase
end

// Sequential logic for state update
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Continuous assignment for output 'z'
assign z = (current_state == E) || (current_state == F);

endmodule