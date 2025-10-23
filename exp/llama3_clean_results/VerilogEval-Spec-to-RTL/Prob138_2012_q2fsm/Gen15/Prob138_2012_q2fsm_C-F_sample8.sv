module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// One-hot encoding for potential power and timing improvements
parameter A = 4'b0001;
parameter B = 4'b0010;
parameter C = 4'b0100;
parameter D = 4'b1000;

// Internal state signal
reg [3:0] current_state;
reg [3:0] next_state;

// Simplified state table using case statement for conciseness and efficiency
always @(*) begin
    case (current_state)
        A: next_state = w? B : A;
        B: next_state = w? C : D;
        C: next_state = w? (4'b0111) : D; // Transition to E
        D: next_state = w? (4'b1111) : A; // Transition to F
        4'b0111: next_state = w? 4'b0111 : D; // State E
        4'b1111: next_state = w? C : D; // State F
        default: next_state = A;
    endcase
end

// State flip-flops with synchronized reset
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// FSM output using a continuous assignment for efficiency
assign z = (current_state == 4'b0111 || current_state == 4'b1111);

endmodule