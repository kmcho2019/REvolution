module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Using one-hot encoding for states to potentially reduce area or power
parameter A = 3'b100;
parameter B = 3'b010;
parameter C = 3'b001;
parameter D = 3'b000;
parameter E = 3'b111;
parameter F = 3'b011;

// Internal state signal
reg [2:0] current_state;
reg [2:0] next_state;

// State table using assign statements
assign next_state = (current_state == A)? (w? B : A) :
                    (current_state == B)? (w? C : D) :
                    (current_state == C)? (w? E : D) :
                    (current_state == D)? (w? F : A) :
                    (current_state == E)? (w? E : D) :
                    (current_state == F)? (w? C : D) :
                    A; // Default state

// State flip-flops with clock gating for power reduction
reg clk_enable;
assign clk_enable = ~(reset); // Enable clock when not in reset

always @(posedge clk)
begin
    if(clk_enable)
    begin
        if(reset)
            current_state <= A;
        else
            current_state <= next_state;
    end
end

// Output z
assign z = (current_state == E || current_state == F);

endmodule