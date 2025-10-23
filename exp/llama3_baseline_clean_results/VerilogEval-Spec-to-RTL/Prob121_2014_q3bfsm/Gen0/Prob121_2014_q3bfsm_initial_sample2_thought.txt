```thought
To implement the finite-state machine (FSM) as described, we need to first define the states and their transitions based on the input 'x'. We will use a 3-bit vector 'y' to represent the current state. The next state 'y_next' will be determined based on the current state 'y' and the input 'x'. The output 'z' will also be determined based on the current state. We will use a case statement to implement the state transitions and output logic. The reset will be synchronous active high, meaning when 'reset' is high, the FSM will reset to state '000' regardless of the current state or input 'x'.
```

```verilog
module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y;
reg [2:0] y_next;

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
    end else begin
        y <= y_next;
    end
end

always @(*) begin
    case (y)
        3'b000: begin
            if (!x) begin
                y_next = 3'b000;
            end else begin
                y_next = 3'b001;
            end
            z = 1'b0;
        end
        3'b001: begin
            if (!x) begin
                y_next = 3'b001;
            end else begin
                y_next = 3'b100;
            end
            z = 1'b0;
        end
        3'b010: begin
            if (!x) begin
                y_next = 3'b010;
            end else begin
                y_next = 3'b001;
            end
            z = 1'b0;
        end
        3'b011: begin
            if (!x) begin
                y_next = 3'b001;
            end else begin
                y_next = 3'b010;
            end
            z = 1'b1;
        end
        3'b100: begin
            if (!x) begin
                y_next = 3'b011;
            end else begin
                y_next = 3'b100;
            end
            z = 1'b1;
        end
        default: begin
            y_next = 3'b000;
            z = 1'b0;
        end
    endcase
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
