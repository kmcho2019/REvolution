module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// States of the FSM
enum logic [2:0] {
    IDLE = 3'b001,
    START = 3'b010,
    RECEIVE = 3'b011,
    STOP = 3'b100,
    ERROR = 3'b101
} state, next_state;

// Register to store the received byte
logic [7:0] byte;

// Counter for the bits received
logic [2:0] bit_count;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        byte <= 8'b0;
        bit_count <= 3'b0;
    end else begin
        state <= next_state;
        case (state)
            START: begin
                byte[0] <= in;
                bit_count <= 1;
            end
            RECEIVE: begin
                byte[bit_count] <= in;
                bit_count <= bit_count + 1;
            end
            default: begin
                bit_count <= 3'b0;
            end
        endcase
    end
end

always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (!in) next_state = START;
            else next_state = IDLE;
        end
        START: begin
            next_state = RECEIVE;
        end
        RECEIVE: begin
            if (bit_count < 8) next_state = RECEIVE;
            else next_state = STOP;
        end
        STOP: begin
            if (in) begin // Correct stop bit received
                next_state = IDLE;
            end else begin // Incorrect stop bit
                next_state = ERROR;
            end
        end
        ERROR: begin
            if (in) next_state = IDLE; // Wait for stop bit to recover
            else next_state = ERROR;
        end
    endcase
end

assign done = (state == STOP && in); // Assert done when stop bit is correct
assign out_byte = byte; // Valid when done is asserted
endmodule