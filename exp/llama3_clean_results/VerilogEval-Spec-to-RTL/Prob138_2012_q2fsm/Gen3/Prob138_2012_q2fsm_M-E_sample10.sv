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

// State table
always @(*)
begin
    case(current_state)
        A: next_state = w? B : A;
        B: next_state = w? C : D;
        C: next_state = w? (2'b100) : D;
        D: next_state = w? (2'b101) : A;
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
wire z1;
assign z1 = (current_state == 2'b10) || (current_state == 2'b11);
wire z2;
assign z2 = (current_state == 2'b100) || (current_state == 2'b101);
assign z = z1 || z2;

endmodule