```thought
To implement the given FSM, we will first define the state codes for each state (A, B, C, D) and then use these state codes to describe the state table and the next state logic. We will use two always blocks: one for the combinational logic that determines the next state based on the current state and inputs, and another for the sequential logic that updates the current state based on the next state and the clock. The outputs g[i] will be assigned based on the current state. We will use a priority-based approach to determine which device gets the grant.
```

```verilog
module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;

// Current state and next state
reg [2:0] current_state;
reg [2:0] next_state;

// State flip-flops
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// State table and next state logic
always @(*) begin
    case (current_state)
        A: begin
            if (r[0]) begin
                next_state = B;
            end else if (r[1]) begin
                next_state = C;
            end else if (r[2]) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (r[0]) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        C: begin
            if (r[1]) begin
                next_state = C;
            end else begin
                next_state = A;
            end
        end
        D: begin
            // This state is not explicitly mentioned in the problem, 
            // so we will assume it acts like state A
            if (r[0]) begin
                next_state = B;
            end else if (r[1]) begin
                next_state = C;
            end else if (r[2]) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        end
        default: next_state = A;
    endcase
end

// Assign outputs based on current state
assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = (current_state == D);

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
