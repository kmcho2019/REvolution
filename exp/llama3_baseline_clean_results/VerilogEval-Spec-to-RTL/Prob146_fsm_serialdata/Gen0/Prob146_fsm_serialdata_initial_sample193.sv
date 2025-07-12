module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// States for the FSM
enum logic [2:0] {
    IDLE,
    START,
    DATA,
    STOP
} state, next_state;

// Register to store the received byte
logic [7:0] byte;

// Counter for the current bit position
logic [2:0] bit_counter;

// Update state and output
always_comb begin
    next_state = state;
    done = 1'b0;
    case (state)
        IDLE: begin
            if (~in) next_state = START;
        end
        START: begin
            next_state = DATA;
        end
        DATA: begin
            if (bit_counter == 7) next_state = STOP;
        end
        STOP: begin
            if (in) begin
                done = 1'b1;
                next_state = IDLE;
            end
        end
    endcase
end

// Update registers
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        byte <= 8'b0;
        bit_counter <= 3'b0;
    end else begin
        state <= next_state;
        case (state)
            START: begin
                bit_counter <= 3'b1;
                byte[0] <= in;
            end
            DATA: begin
                bit_counter <= bit_counter + 1'b1;
                byte[bit_counter] <= in;
            end
            STOP: begin
                out_byte <= byte;
            end
        endcase
    end
end

endmodule