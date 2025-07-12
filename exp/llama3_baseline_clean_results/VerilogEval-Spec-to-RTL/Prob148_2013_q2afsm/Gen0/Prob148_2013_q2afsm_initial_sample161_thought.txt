```thought
To implement the given FSM, we first need to define the states and their corresponding outputs. We will use four states: A, B, C, and D. State A is the idle state where no grants are given. States B, C, and D correspond to granting access to devices 0, 1, and 2 respectively.

The state transitions will be controlled by the inputs r and the current state. The state table will determine the next state based on the current state and inputs.

We will use two always blocks, one for the state table and one for the state flip-flops. The state table will determine the next state, and the state flip-flops will update the current state on the positive edge of the clock.

The outputs g will be determined by the current state, so we will use continuous assignment statements to set the outputs based on the current state.

We will also handle the reset condition by setting the initial state to A when resetn is low.
```

```verilog
module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define the states
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;

// Declare the state register
reg [2:0] state;
reg [2:0] next_state;

// Continuous assignment statements for outputs
assign g[0] = (state == B) ? 1'b1 : 1'b0;
assign g[1] = (state == C) ? 1'b1 : 1'b0;
assign g[2] = (state == D) ? 1'b1 : 1'b0;

// State table
always @(*)
begin
    case(state)
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
            next_state = A; // We don't need to check for r[2] here because we know r[2] is 1
        default: 
            next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk or negedge resetn)
begin
    if (~resetn) 
        state <= A;
    else 
        state <= next_state;
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
