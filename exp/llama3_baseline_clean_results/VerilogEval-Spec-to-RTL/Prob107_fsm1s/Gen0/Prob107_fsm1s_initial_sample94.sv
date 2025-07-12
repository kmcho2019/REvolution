module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
parameter B = 1'b0, A = 1'b1;

// Internal state register
reg current_state;
reg next_state;

// Output assignment based on current state
always @(*)
begin
    case(current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0;
    endcase
end

// State transition logic
always @(*)
begin
    case(current_state)
        B: 
            if(in == 1'b0)
                next_state = B;
            else if(in == 1'b1)
                next_state = B;
        A: 
            if(in == 1'b0)
                next_state = B;
            else if(in == 1'b1)
                next_state = A;
        default: next_state = B;
    endcase
end

// Synchronous reset
always @(posedge clk)
begin
    if(reset == 1'b1)
        current_state <= B;
    else
        current_state <= next_state;
end

endmodule