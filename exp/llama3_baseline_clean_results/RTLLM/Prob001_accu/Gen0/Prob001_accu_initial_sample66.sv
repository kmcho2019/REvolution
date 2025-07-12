```thought
To solve this problem, we will use a finite state machine (FSM) to track the number of valid input data received. We'll have two states: IDLE and ACCUMULATING. When valid_in is 1, we transition from IDLE to ACCUMULATING and start accumulating the input data. We'll use a counter to keep track of the number of data received. Once we've received 4 data, we'll calculate the accumulated sum, output it, and set valid_out to 1 for one cycle. We'll then reset the FSM to IDLE. If the reset signal is asserted, we'll reset the FSM to IDLE and clear all internal signals.
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

reg     [1:0]       state;
reg     [1:0]       next_state;
reg     [9:0]       sum;
reg     [1:0]       cnt;
reg     [9:0]       next_sum;
reg     [1:0]       next_cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state       <= 2'b00;
        sum         <= 10'b0;
        cnt         <= 2'b0;
    end else begin
        state       <= next_state;
        sum         <= next_sum;
        cnt         <= next_cnt;
    end
end

always @(*) begin
    next_state     = state;
    next_sum       = sum;
    next_cnt       = cnt;
    valid_out      = 1'b0;
    case (state)
        2'b00: begin // IDLE
            if (valid_in) begin
                next_state = 2'b01;
                next_sum   = data_in;
                next_cnt   = 2'b1;
            end
        end
        2'b01: begin // ACCUMULATING
            if (valid_in) begin
                next_sum   = sum + data_in;
                next_cnt   = cnt + 1'b1;
                if (cnt == 2'b11) begin
                    next_state = 2'b00;
                    valid_out  = 1'b1;
                end
            end else begin
                next_state = 2'b01;
            end
        end
        default: begin
            next_state = 2'b00;
        end
    endcase
end

assign data_out = sum;

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
