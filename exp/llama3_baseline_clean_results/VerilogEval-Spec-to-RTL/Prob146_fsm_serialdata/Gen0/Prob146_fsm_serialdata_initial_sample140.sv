module TopModule (
    input         clk,
    input         in,
    input         reset,
    output [7:0]  out_byte,
    output        done
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE,
    START,
    DATA,
    STOP
} state, next_state;

// Define the counter for the data bits
logic [2:0] data_count;

// Define the register to hold the received byte
logic [7:0] byte_reg;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_count <= 0;
        byte_reg <= 0;
    end else begin
        state <= next_state;
        if (next_state == DATA) begin
            // Shift in the new data bit
            byte_reg <= {byte_reg[6:0], in};
            data_count <= data_count + 1;
        end else if (next_state == IDLE) begin
            data_count <= 0;
            byte_reg <= 0;
        end
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    done = 0;
    out_byte = byte_reg;
    case (state)
        IDLE: begin
            if (~in) begin
                next_state = START;
            end
        end
        START: begin
            if (in) begin
                next_state = IDLE;
            end else begin
                next_state = DATA;
            end
        end
        DATA: begin
            if (data_count == 8) begin
                next_state = STOP;
            end
        end
        STOP: begin
            done = 1;
            if (in) begin
                next_state = IDLE;
            end
        end
    endcase
end

endmodule