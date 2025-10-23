```thought
To implement the accu module, we will use a finite state machine (FSM) to track the number of valid input data received. We will also use a counter to keep track of the accumulated sum. The FSM will have two states: an idle state and an accumulation state. When valid_in is 1, the FSM will transition from idle to accumulation state and start accumulating the input data. After four valid input data are received, the FSM will output the accumulated sum and set valid_out to 1 for one cycle. We will also use a register to store the accumulated sum and another register to store the current count of valid input data received.
```

```verilog
module accu (
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg [9:0] accum_sum;
reg [1:0] count;
reg       valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accum_sum <= 10'd0;
        count <= 2'd0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            if (count == 2'd0) begin
                accum_sum <= data_in;
                count <= count + 1;
            end else if (count < 2'd4) begin
                accum_sum <= accum_sum + data_in;
                count <= count + 1;
            end else begin
                accum_sum <= accum_sum + data_in;
                count <= 2'd0;
                valid_out_reg <= 1'b1;
            end
        end else begin
            if (valid_out_reg) begin
                valid_out_reg <= 1'b0;
            end
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = accum_sum;

endmodule
```

This code implements the accu module as described in the specification. The `accum_sum` register stores the accumulated sum of the input data, and the `count` register keeps track of the number of valid input data received. The `valid_out_reg` register stores the value of the `valid_out` signal. The `always` block is used to update the registers at the positive edge of the clock. The `if` statements inside the `always` block implement the logic of the FSM. When `valid_in` is 1, the FSM accumulates the input data and increments the `count` register. When the `count` register reaches 4, the FSM outputs the accumulated sum and sets `valid_out` to 1 for one cycle.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
