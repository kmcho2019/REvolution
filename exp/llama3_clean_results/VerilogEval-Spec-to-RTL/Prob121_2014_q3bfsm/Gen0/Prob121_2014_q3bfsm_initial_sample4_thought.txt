```thought
The finite-state machine (FSM) has three states represented by y[2:0]. To implement the FSM, we will use a Moore machine approach, where the output is a function of the current state only. We can encode the states as 000, 001, 010, 011, and 100. We will use a 3-bit register to store the current state and update it based on the next-state table. We will also implement a synchronous reset to reset the FSM to state 000 when the reset signal is high.
```

```verilog
module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

// state encoding
parameter S000 = 3'b000;
parameter S001 = 3'b001;
parameter S010 = 3'b010;
parameter S011 = 3'b011;
parameter S100 = 3'b100;

// combinational logic for next state
always @(*)
begin
    case (y)
        S000: next_y = x ? S001 : S000;
        S001: next_y = x ? S100 : S001;
        S010: next_y = x ? S001 : S010;
        S011: next_y = x ? S010 : S001;
        S100: next_y = x ? S100 : S011;
        default: next_y = S000; // default state
    endcase
end

// sequential logic for state update
always @(posedge clk)
begin
    if (reset) begin
        y <= S000; // synchronous reset
    end else begin
        y <= next_y; // update state
    end
end

// output logic
assign z = (y == S011 || y == S100) ? 1'b1 : 1'b0;

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
