```thought
To implement the finite-state machine (FSM) as described, we will use a combination of combinational logic to determine the next state and sequential logic to update the current state. We will also include the synchronous active high reset logic to reset the FSM to state "000" when the reset signal is high. The output z will be determined based on the current state. The FSM will have three states, represented by a 3-bit vector y[2:0]. We will use a case statement to define the next state logic and the output z.
```

```verilog
module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y;
reg [2:0] next_y;

always @(*) begin
    case(y)
        3'b000: next_y = x ? 3'b001 : 3'b000;
        3'b001: next_y = x ? 3'b100 : 3'b001;
        3'b010: next_y = x ? 3'b001 : 3'b010;
        3'b011: next_y = x ? 3'b010 : 3'b001;
        3'b100: next_y = x ? 3'b100 : 3'b011;
        default: next_y = 3'b000;
    endcase
    
    case(y)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        y <= 3'b000;
    end else begin
        y <= next_y;
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
