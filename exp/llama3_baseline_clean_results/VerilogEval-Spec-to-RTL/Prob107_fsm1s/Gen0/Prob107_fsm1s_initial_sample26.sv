module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state; // 1-bit signal to represent the two states
reg [0:0] next_state;

// Define the states
parameter B = 1'b1;
parameter A = 1'b0;

// Define the output based on the current state
always @(*)
begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0;
    endcase
end

// Determine the next state based on the current state and the input
always @(*)
begin
    case(state)
        B: 
            if(in == 1'b0)
                next_state = A;
            else
                next_state = B;
        A: 
            if(in == 1'b0)
                next_state = B;
            else
                next_state = A;
        default: next_state = B;
    endcase
end

// Update the state on the rising edge of the clock
always @(posedge clk)
begin
    if(reset == 1'b1)
        state <= B;
    else
        state <= next_state;
end

endmodule