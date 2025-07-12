```thought
To solve this problem, we can use a finite state machine (FSM) with four main states: Idle, Start, Data, and Stop. 
- In the Idle state, we wait for the start bit (0) to begin receiving a byte.
- Once the start bit is detected, we transition to the Start state, where we wait for one clock cycle.
- Then, we enter the Data state, where we shift in the 8 data bits into a register.
- After receiving all 8 data bits, we transition to the Stop state, where we verify the stop bit (1).
- If the stop bit is correct, we assert the done signal and output the received byte.
- If the stop bit is incorrect, we stay in the Stop state until a stop bit (1) is received, then we transition back to the Idle state.
- The FSM also has a synchronous reset that resets the state to Idle and clears the output when reset is high.
```
```verilog
module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define the states
enum logic [1:0] {Idle, Start, Data, Stop} state, next_state;

// Internal registers
logic [7:0] data_reg;
logic [2:0] count;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        data_reg <= 8'b0;
        count <= 3'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            Idle: begin
                done <= 1'b0;
            end
            Start: begin
                done <= 1'b0;
            end
            Data: begin
                done <= 1'b0;
            end
            Stop: begin
                done <= 1'b1;
            end
        endcase
        case (next_state)
            Idle: begin
                data_reg <= 8'b0;
                count <= 3'b0;
            end
            Start: begin
                data_reg <= 8'b0;
                count <= 3'b0;
            end
            Data: begin
                data_reg <= {data_reg[6:0], in};
                count <= count + 1'b1;
            end
            Stop: begin
                out_byte <= data_reg;
            end
        endcase
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    case (state)
        Idle: begin
            if (!in) begin
                next_state = Start;
            end
        end
        Start: begin
            next_state = Data;
        end
        Data: begin
            if (count == 7) begin
                next_state = Stop;
            end
        end
        Stop: begin
            if (in) begin
                next_state = Idle;
            end
        end
    endcase
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
