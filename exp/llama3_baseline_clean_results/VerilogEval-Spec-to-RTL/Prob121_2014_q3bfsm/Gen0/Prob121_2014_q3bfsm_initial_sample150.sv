```thought
To implement the finite-state machine (FSM) as described, we will first define the states and their corresponding next states based on the input x. We'll use a 3-bit vector to represent the current state (y) and the next state. The output z will be determined by the current state. Since reset is synchronous and active high, we will include a reset condition in the combinational logic that determines the next state and the output. The FSM will be implemented using a combination of sequential logic (to store the current state) and combinational logic (to determine the next state and the output based on the current state and input x).
```

```verilog
module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // Current state
reg [2:0] next_y; // Next state
wire z_out; // Output z

// Combinational logic to determine next state and output z
always @(*) begin
    case (y)
        3'b000: begin
            if (~x) next_y = 3'b000;
            else next_y = 3'b001;
            z_out = 1'b0;
        end
        3'b001: begin
            if (~x) next_y = 3'b001;
            else next_y = 3'b100;
            z_out = 1'b0;
        end
        3'b010: begin
            if (~x) next_y = 3'b010;
            else next_y = 3'b001;
            z_out = 1'b0;
        end
        3'b011: begin
            if (~x) next_y = 3'b001;
            else next_y = 3'b010;
            z_out = 1'b1;
        end
        3'b100: begin
            if (~x) next_y = 3'b011;
            else next_y = 3'b100;
            z_out = 1'b1;
        end
        default: begin
            next_y = 3'b000;
            z_out = 1'b0;
        end
    endcase
end

// Sequential logic to update current state on positive edge of clock
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // Synchronous reset
    end else begin
        y <= next_y;
    end
end

assign z = z_out; // Assign output

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
