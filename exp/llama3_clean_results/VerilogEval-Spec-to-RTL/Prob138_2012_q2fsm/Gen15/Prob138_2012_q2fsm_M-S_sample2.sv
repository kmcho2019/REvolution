module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Maintaining one-hot encoding for its potential benefits in timing and power
parameter A = 3'b001;
parameter B = 3'b010;
parameter C = 3'b100;
parameter D = 3'b000;
parameter E = 3'b011;
parameter F = 3'b101;

// Internal state signal
reg [2:0] current_state;
reg [2:0] next_state;

// State table logic remains concise and efficient
assign next_state = (current_state == A)? (w? B : A) :
                    (current_state == B)? (w? C : D) :
                    (current_state == C)? (w? E : D) :
                    (current_state == D)? (w? F : A) :
                    (current_state == E)? (w? E : D) :
                    (current_state == F)? (w? C : D) :
                    A;

// State flip-flops with synchronized reset remain the same
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Output z remains efficiently implemented
assign z = (current_state == E || current_state == F);

endmodule