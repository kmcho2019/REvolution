module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Enum for states
enum {IDLE, START_BIT, DATA_BITS, STOP_BIT, DONE} state, next_state;

// Registers for data byte and done signal
reg [7:0] data_byte;
reg done_reg;

// Counter for bit position
reg [2:0] bit_counter;

// Always block for combinational logic
always @(*) begin
    next_state = state;
    done_reg = 0;
    case (state)
        IDLE: begin
            if (!in) next_state = START_BIT;
        end
        START_BIT: begin
            next_state = DATA_BITS;
            data_byte = 0;
            bit_counter = 0;
        end
        DATA_BITS: begin
            if (bit_counter == 7) next_state = STOP_BIT;
            bit_counter = bit_counter + 1;
            data_byte = {data_byte[6:0], in};
        end
        STOP_BIT: begin
            if (in) next_state = DONE;
            else next_state = IDLE; // Invalid stop bit, wait for next start bit
        end
        DONE: begin
            next_state = IDLE;
            done_reg = 1;
        end
    endcase
end

// Always block for sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_byte <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        out_byte <= (done_reg) ? data_byte : out_byte;
        done <= done_reg;
    end
end

endmodule