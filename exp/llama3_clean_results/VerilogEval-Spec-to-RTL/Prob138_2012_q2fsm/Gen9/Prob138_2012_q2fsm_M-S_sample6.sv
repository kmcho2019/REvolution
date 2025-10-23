module TopModule(
    input  clk,
    input  reset,
    input  w,
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

// State flip-flops
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// State table using always block
always @(*)
begin
    case(current_state)
        A: next_state = w? B : A;
        B: next_state = w? C : D;
        C: next_state = w? {1'b1, 1'b0} : D;
        D: next_state = w? {1'b1, 1'b1} : A;
        {1'b1, 1'b0}: next_state = w? {1'b1, 1'b0} : D;
        {1'b1, 1'b1}: next_state = w? C : D;
        default: next_state = A;
    endcase
end

// Output z
assign z = (current_state[1] == 1'b1);

endmodule