```thought
To implement the accu module, we will use a finite state machine (FSM) to keep track of the number of valid input data received. The FSM will have two states: IDLE and ACCUMULATE. In the IDLE state, the module waits for the valid_in signal to be set to 1. Once the valid_in signal is set to 1, the module transitions to the ACCUMULATE state and starts accumulating the input data. The accumulation is done using a register to store the sum of the input data. After four valid input data are received, the module outputs the accumulated sum and sets the valid_out signal to 1 for one cycle. The module then resets the accumulation register and returns to the IDLE state.
```

```verilog
module accu(
    input         clk,
    input         rst_n,
    input  [7:0]  data_in,
    input         valid_in,
    output        valid_out,
    output [9:0]  data_out
);

reg [9:0] accu_reg;
reg [1:0]  counter;
reg         valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accu_reg <= 10'd0;
        counter <= 2'd0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin
        if (counter == 2'd0) begin
            accu_reg <= data_in;
            counter <= counter + 1'b1;
        end else if (counter == 2'd1) begin
            accu_reg <= accu_reg + data_in;
            counter <= counter + 1'b1;
        end else if (counter == 2'd2) begin
            accu_reg <= accu_reg + data_in;
            counter <= counter + 1'b1;
        end else if (counter == 2'd3) begin
            accu_reg <= accu_reg + data_in;
            valid_out_reg <= 1'b1;
            counter <= 2'd0;
        end
    end else begin
        valid_out_reg <= 1'b0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = (valid_out_reg) ? accu_reg : 10'd0;

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
