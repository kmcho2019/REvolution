module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Current state and next state
reg [1:0] state;
reg [1:0] next_state;

// Output based on current state
always @(*)
begin
    case(state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0; // default output
    endcase
end

// State transition logic
always @(*)
begin
    case(state)
        A: 
            if(in == 1'b0) 
                next_state = A;
            else 
                next_state = B;
        B: 
            if(in == 1'b0) 
                next_state = C;
            else 
                next_state = B;
        C: 
            if(in == 1'b0) 
                next_state = A;
            else 
                next_state = D;
        D: 
            if(in == 1'b0) 
                next_state = C;
            else 
                next_state = B;
        default: next_state = A; // default next state
    endcase
end

// Synchronous reset
always @(posedge clk)
begin
    if(reset == 1'b1) 
        state <= A;
    else 
        state <= next_state;
end

endmodule