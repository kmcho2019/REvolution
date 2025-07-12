module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

// States of the FSM
enum logic [2:0] {
    IDLE = 3'b000,
    START = 3'b001,
    DATA = 3'b010,
    STOP = 3'b011,
    ERROR = 3'b100
} state, next_state;

// Bit counter for DATA state
logic [2:0] bit_counter;

// Signal to indicate if a byte has been received
logic byte_received;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        byte_received <= 1'b0;
        bit_counter <= 3'b000;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (~in) begin
                    next_state <= START;
                end else begin
                    next_state <= IDLE;
                end
            end
            START: begin
                if (~in) begin
                    next_state <= DATA;
                    bit_counter <= 3'b001;
                end else begin
                    next_state <= IDLE;
                end
            end
            DATA: begin
                if (bit_counter == 3'b100) begin
                    next_state <= STOP;
                end else begin
                    next_state <= DATA;
                    bit_counter <= bit_counter + 1'b1;
                end
            end
            STOP: begin
                if (in) begin
                    byte_received <= 1'b1;
                    next_state <= IDLE;
                end else begin
                    next_state <= ERROR;
                end
            end
            ERROR: begin
                if (in) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= ERROR;
                end
            end
        endcase
    end
end

always_comb begin
    case (state)
        IDLE: begin
            done = 1'b0;
        end
        START: begin
            done = 1'b0;
        end
        DATA: begin
            done = 1'b0;
        end
        STOP: begin
            done = 1'b0;
        end
        ERROR: begin
            done = 1'b0;
        end
        default: begin
            if (byte_received) begin
                done = 1'b1;
                byte_received <= 1'b0;
            end else begin
                done = 1'b0;
            end
        end
    endcase
end

endmodule