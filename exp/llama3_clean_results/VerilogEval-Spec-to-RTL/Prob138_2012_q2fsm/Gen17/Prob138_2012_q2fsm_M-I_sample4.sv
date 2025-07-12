module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// State codes using one-hot encoding for potential area and power benefits
parameter A = 4'b0001;
parameter B = 4'b0010;
parameter C = 4'b0100;
parameter D = 4'b1000;

// Internal state signal
reg [3:0] current_state;
reg [3:0] next_state;

// State table using assign statements with one-hot encoding
assign next_state = (current_state == A)? (w? B : A) :
                    (current_state == B)? (w? C : D) :
                    (current_state == C)? (w? B : D) :
                    (current_state == D)? (w? C : A) :
                    A; // Default state

// State flip-flops with clock gating for power reduction
reg clk_gated;
always @(posedge clk)
begin
    if(reset)
        clk_gated <= 1'b0;
    else if(current_state!= next_state)
        clk_gated <= 1'b1;
    else
        clk_gated <= 1'b0;
end

always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else if(clk_gated)
        current_state <= next_state;
end

// Output z using a continuous assignment for simplicity
assign z = (current_state == C || current_state == D);

endmodule