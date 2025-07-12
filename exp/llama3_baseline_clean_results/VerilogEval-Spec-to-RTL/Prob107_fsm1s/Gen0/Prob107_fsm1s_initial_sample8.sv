module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] current_state, next_state;

// Define the states
localparam A = 2'b01;
localparam B = 2'b10;

// State transitions
always @(*)
begin
    case(current_state)
        B: 
            if (in == 1'b0)
                next_state = B;
            else
                next_state = B;
        A: 
            if (in == 1'b0)
                next_state = B;
            else
                next_state = A;
        default: 
            next_state = B;
    endcase
end

// Output logic
always @(*)
begin
    case(current_state)
        A: out = 1'b0;
        B: out = 1'b1;
        default: out = 1'b1;
    endcase
end

// Update current state
always @(posedge clk)
begin
    if (reset)
        current_state <= B;
    else
        current_state <= next_state;
end

initial
    current_state = B;

endmodule