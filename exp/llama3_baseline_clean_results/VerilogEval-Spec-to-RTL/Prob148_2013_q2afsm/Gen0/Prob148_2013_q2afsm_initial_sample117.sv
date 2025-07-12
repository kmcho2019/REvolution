```thought
To implement the given FSM, we can first define the state codes for each state. We'll use 2 bits to represent the four states: A, B, C, and D. The state A will be the reset state. We'll use two always blocks, one for the next state logic and one for the state flip-flops. The next state logic will determine the next state based on the current state and the inputs. The state flip-flops will update the current state on the positive edge of the clock. For the output logic, we can use continuous assignment statements to assign the output values based on the current state.
```

```verilog
module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Declare current state and next state
reg [1:0] curr_state;
reg [1:0] next_state;

// State flip-flops
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        curr_state <= A;
    end else begin
        curr_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (curr_state)
        A: begin
            if (r[0] == 1'b1) begin
                next_state = B;
            end else if (r[1] == 1'b1) begin
                next_state = C;
            end else if (r[2] == 1'b1) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (r[0] == 1'b1) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        C: begin
            if (r[1] == 1'b1) begin
                next_state = C;
            end else begin
                next_state = A;
            end
        end
        D: begin
            // This state is not actually reachable according to the problem description
            // But we include it for completeness
            next_state = A;
        end
    endcase
end

// Output logic
assign g[0] = (curr_state == B);
assign g[1] = (curr_state == C);
assign g[2] = (curr_state == D);

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
