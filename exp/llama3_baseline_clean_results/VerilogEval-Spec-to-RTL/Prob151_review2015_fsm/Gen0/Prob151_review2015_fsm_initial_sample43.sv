```thought
The finite-state machine can be designed as a Moore machine with five states: Idle, Found_1, Found_11, Found_110, Found_1101, Shift, Count, and Done. The state machine starts in the Idle state and searches for the pattern 1101 on the data input. Once the pattern is detected, it transitions to the Shift state and asserts shift_ena for 4 clock cycles. After that, it transitions to the Count state, asserts counting, and waits until done_counting is high. Then, it transitions to the Done state, asserts done, and waits until ack is high before returning to the Idle state.
```

```verilog
module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [2:0] state;
reg [1:0] shift_count;
reg shift_ena_reg;
reg counting_reg;
reg done_reg;

localparam IDLE        = 3'b000;
localparam FOUND_1      = 3'b001;
localparam FOUND_11     = 3'b010;
localparam FOUND_110    = 3'b011;
localparam FOUND_1101   = 3'b100;
localparam SHIFT        = 3'b101;
localparam COUNT        = 3'b110;
localparam DONE         = 3'b111;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena_reg <= 1'b0;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
        shift_count <= 2'b00;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    state <= FOUND_1;
                end
            end
            FOUND_1: begin
                if (data == 1'b1) begin
                    state <= FOUND_11;
                end else if (data == 1'b0) begin
                    state <= IDLE;
                end
            end
            FOUND_11: begin
                if (data == 1'b0) begin
                    state <= FOUND_110;
                end else if (data == 1'b1) begin
                    state <= FOUND_1;
                end
            end
            FOUND_110: begin
                if (data == 1'b1) begin
                    state <= FOUND_1101;
                end else if (data == 1'b0) begin
                    state <= IDLE;
                end
            end
            FOUND_1101: begin
                state <= SHIFT;
                shift_count <= 2'b00;
                shift_ena_reg <= 1'b1;
            end
            SHIFT: begin
                shift_count <= shift_count + 1;
                if (shift_count == 2'b11) begin
                    shift_ena_reg <= 1'b0;
                    state <= COUNT;
                    counting_reg <= 1'b1;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    counting_reg <= 1'b0;
                    state <= DONE;
                    done_reg <= 1'b1;
                end
            end
            DONE: begin
                if (ack) begin
                    done_reg <= 1'b0;
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

assign shift_ena = shift_ena_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
