```thought
To implement the finite-state machine (FSM) as described, we will use a combination of always blocks for sequential logic (to handle state transitions) and combinational logic (to determine the next state and output based on the current state and input x). The states will be encoded as binary numbers, with the current state represented by the variable `y`. The next state and output will be determined based on the current state and the value of `x`. We will use synchronous reset, which means the reset will be active on the positive edge of the clock when `reset` is high.
```

```verilog
module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // Current state

always @(posedge clk) begin
    if (reset) begin // Synchronous active high reset
        y <= 3'b000; // Reset state
    end else begin
        case (y)
            3'b000: y <= x ? 3'b001 : 3'b000;
            3'b001: y <= x ? 3'b100 : 3'b001;
            3'b010: y <= x ? 3'b001 : 3'b010;
            3'b011: y <= x ? 3'b010 : 3'b001;
            3'b100: y <= x ? 3'b100 : 3'b011;
            default: y <= 3'b000; // Default to state 000 if not explicitly defined
        endcase
    end
end

always @(*) begin
    case (y)
        3'b000, 3'b001, 3'b010: z = 1'b0;
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0; // Default output if not explicitly defined
    endcase
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
