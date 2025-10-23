module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Internal state signal
reg [2:0] current_state;
reg [2:0] next_state;

// State flip-flops with synchronized reset
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// State table using a case statement for clarity
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

// Output z based on the current state
always @(*)
begin
    case(current_state)
        E, F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule