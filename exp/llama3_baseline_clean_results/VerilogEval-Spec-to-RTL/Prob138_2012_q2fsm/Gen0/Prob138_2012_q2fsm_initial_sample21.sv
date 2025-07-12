module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define state codes
parameter A = 5'b00001;
parameter B = 5'b00010;
parameter C = 5'b00100;
parameter D = 5'b01000;
parameter E = 5'b10000;
parameter F = 5'b00011;  // Using an unused state code for simplicity

// Define current and next state
reg [4:0] current_state;
reg [4:0] next_state;

// State table
always @(*)
begin
    case(current_state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
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

// FSM output, z
assign z = (current_state == E || current_state == F) ? 1'b1 : 1'b0;

endmodule