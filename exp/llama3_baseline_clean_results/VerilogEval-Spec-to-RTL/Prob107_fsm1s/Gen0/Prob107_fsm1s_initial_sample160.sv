module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the states
parameter A = 1'b0;
parameter B = 1'b1;

reg [0:0] state; // Initialize state as a 1-bit reg
reg [0:0] next_state; // Initialize next_state as a 1-bit reg

// Output logic
always @(*)
begin
    case(state)
        A: out = 1'b0;
        B: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// Next state logic
always @(*)
begin
    case(state)
        A: 
            if (!in) 
                next_state = B;
            else 
                next_state = A;
        B: 
            if (!in) 
                next_state = A;
            else 
                next_state = B;
        default: next_state = B;
    endcase
end

// State update logic with synchronous reset
always @(posedge clk)
begin
    if (reset) 
        state <= B;
    else 
        state <= next_state;
end

endmodule