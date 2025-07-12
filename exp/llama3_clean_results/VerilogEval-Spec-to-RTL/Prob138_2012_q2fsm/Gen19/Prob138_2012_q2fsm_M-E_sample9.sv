module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// State codes using a hybrid approach
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;
parameter E = 3'b100; // Using 3 bits for E and F to differentiate them
parameter F = 3'b101;

// Internal state signals
reg [2:0] current_state;
reg [2:0] next_state;

// Counter for sequence management
reg [1:0] sequence_counter;

// Simplified state table using a case statement for clarity
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

// State flip-flops with synchronized reset
always @(posedge clk)
begin
    if(reset)
    begin
        current_state <= A;
        sequence_counter <= 0;
    end
    else
    begin
        current_state <= next_state;
        // Update sequence counter based on state transitions
        if((current_state == A && next_state == B) ||
           (current_state == B && next_state == C) ||
           (current_state == C && next_state == E))
            sequence_counter <= sequence_counter + 1;
        else if((current_state == D && next_state == A) ||
                (current_state == E && next_state == D) ||
                (current_state == F && next_state == D))
            sequence_counter <= 0;
    end
end

// Output z using a continuous assignment for efficiency
assign z = (current_state == E || current_state == F);

endmodule