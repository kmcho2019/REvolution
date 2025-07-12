```thought
To implement the given FSM, we first need to define the states. We can use 2-bit binary codes for the states A, B, C, and D. We will then implement the state transition table using an always block, and update the current state using another always block. Since the output g is dependent on the current state, we can use continuous assignment statements to define the output g. We will prioritize device 0 over device 1 and device 1 over device 2 when deciding which device receives a grant.
```

```verilog
module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Declare current state and next state
reg [1:0] current_state;
reg [1:0] next_state;

// Continuous assignment for output g
assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = 1'b0;

// Always block for state transition table
always @(*)
begin
    case(current_state)
        A:
            if (!r[2] && !r[1] && !r[0])
                next_state = A;
            else if (r[0])
                next_state = B;
            else if (r[1])
                next_state = C;
            else
                next_state = D;
        B:
            if (r[0])
                next_state = B;
            else
                next_state = A;
        C:
            if (r[1])
                next_state = C;
            else
                next_state = A;
        D:
            next_state = A; // D is not actually used in this implementation
        default:
            next_state = A;
    endcase
end

// Always block for state flip-flops
always @(posedge clk)
begin
    if (!resetn)
        current_state <= A;
    else
        current_state <= next_state;
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
