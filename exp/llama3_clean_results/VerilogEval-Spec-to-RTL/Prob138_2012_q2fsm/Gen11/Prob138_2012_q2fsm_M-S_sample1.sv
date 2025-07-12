module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// State codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Internal state signal
reg [1:0] current_state;
reg [1:0] next_state;

// State table using case statement
always @(*)
begin
    case (current_state)
        A: next_state = w? B : A;
        B: next_state = w? C : D;
        C: next_state = w? (2'b11) : D; // for states E and F, use 2'b11
        D: next_state = w? (2'b10) : A; // 
        default: next_state = A;
    endcase
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
assign z = (current_state == 2'b11 || current_state == 2'b10);

endmodule