module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] shift_reg; // shift register to store incoming bits
reg [3:0] delay_reg; // register to store delay bits
reg [3:0] count_reg; // register to display remaining time
reg counting_reg; // register to assert counting signal
reg done_reg; // register to assert done signal

reg [11:0] counter; // counter to count for specified delay duration

// states of the FSM
reg [1:0] state; // 0: IDLE, 1: SHIFT_DELAY, 2: COUNTING, 3: DONE
reg [1:0] next_state;

// state transitions
always @(posedge clk) begin
    if(reset) begin
        state <= 0; // reset to IDLE state
        shift_reg <= 0;
        delay_reg <= 0;
        count_reg <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        counter <= 0;
    end else begin
        case(state)
            0: begin // IDLE state
                if(shift_reg == 4'b1101) begin // start pattern detected
                    state <= 1; // transition to SHIFT_DELAY state
                    shift_reg <= 0; // reset shift register
                end else begin
                    shift_reg <= {shift_reg[2:0], data}; // shift in incoming bits
                end
            end
            1: begin // SHIFT_DELAY state
                shift_reg <= {shift_reg[2:0], data}; // shift in delay bits
                if(&shift_reg[3:0]) begin // all delay bits shifted in
                    state <= 2; // transition to COUNTING state
                    delay_reg <= shift_reg[3:0]; // store delay bits
                    count_reg <= delay_reg; // initialize count register
                    counting_reg <= 1; // assert counting signal
                    counter <= 0; // reset counter
                end
            end
            2: begin // COUNTING state
                if(counter == (delay_reg + 1) * 1000 - 1) begin // counting finished
                    state <= 3; // transition to DONE state
                    counting_reg <= 0; // deassert counting signal
                    done_reg <= 1; // assert done signal
                end else begin
                    counter <= counter + 1; // increment counter
                    if(counter % 1000 == 0) begin // decrement count register every 1000 cycles
                        count_reg <= count_reg - 1;
                    end
                end
            end
            3: begin // DONE state
                if(ack) begin // ack signal asserted
                    state <= 0; // transition to IDLE state
                    done_reg <= 0; // deassert done signal
                end
            end
        endcase
    end
end

// output assignments
assign count = count_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule