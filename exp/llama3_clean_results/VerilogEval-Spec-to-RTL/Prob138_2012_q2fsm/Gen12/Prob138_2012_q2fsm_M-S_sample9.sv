module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// State codes using binary encoding for simplicity
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Internal state signal
reg [1:0] current_state;
reg [1:0] next_state;

// Simplified state table using assign statements
assign next_state = (current_state == A)? (w? B : A) :
                    (current_state == B)? (w? C : D) :
                    (current_state == C)? (w? D : D) :
                    (current_state == D)? (w? D : A) :
                    A; // Default state

// State flip-flops with synchronized reset
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Output z using a continuous assignment for efficiency
assign z = (current_state == C || current_state == D);

endmodule