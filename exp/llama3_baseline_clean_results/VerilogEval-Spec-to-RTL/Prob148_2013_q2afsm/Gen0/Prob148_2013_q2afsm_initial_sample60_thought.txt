```thought
To implement the given FSM, we can use a simple state machine with four states (A, B, C, D) and assign state codes as follows: A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11. We will use separate always blocks for the state table and the state flip-flops. We will also use continuous assignment statements to describe the FSM outputs, g[i]. We will prioritize device 0 over device 1 and device 2, and only grant device 2 if it is the only device making a request when the FSM is in state A.
```

```verilog
module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
reg [1:0] current_state;
reg [1:0] next_state;

// Output g
assign g[0] = (current_state == B) ? 1'b1 : 1'b0;
assign g[1] = (current_state == C) ? 1'b1 : 1'b0;
assign g[2] = 1'b0; // Device 2 is never granted in the provided FSM

// State table
always @(*)
begin
    case (current_state)
        A:
            if (r[0] == 1'b1)
                next_state = B;
            else if (r[1] == 1'b1)
                next_state = C;
            else if (r[2] == 1'b1)
                next_state = D;
            else
                next_state = A;
        B:
            if (r[0] == 1'b1)
                next_state = B;
            else
                next_state = A;
        C:
            if (r[1] == 1'b1)
                next_state = C;
            else
                next_state = A;
        D:
            // This state is not actually used in the provided FSM, 
            // but it's included here for completeness
            next_state = A;
        default:
            next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if (~resetn)
        current_state <= A;
    else
        current_state <= next_state;
end

endmodule
```
Note: The state D is not actually used in the provided FSM, but it's included here for completeness. The state D will immediately transition to state A, regardless of the inputs.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
