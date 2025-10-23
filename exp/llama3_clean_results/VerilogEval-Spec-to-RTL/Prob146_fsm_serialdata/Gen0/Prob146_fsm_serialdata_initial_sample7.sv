module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE,
    START,
    DATA,
    STOP,
    WAIT_FOR_STOP
} state, next_state;

// Register to store the received byte
logic [7:0] byte;

// Counter for the data bits
logic [2:0] bit_count;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_byte <= 8'b0;
        done <= 1'b0;
        byte <= 8'b0;
        bit_count <= 3'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state <= START;
                end else begin
                    next_state <= IDLE;
                end
            end
            START: begin
                next_state <= DATA;
                byte[0] <= in;
                bit_count <= 1;
            end
            DATA: begin
                if (bit_count == 8'd8) begin
                    next_state <= STOP;
                end else begin
                    next_state <= DATA;
                    byte[bit_count] <= in;
                    bit_count <= bit_count + 1;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    next_state <= IDLE;
                    out_byte <= byte;
                    done <= 1'b1;
                end else begin
                    next_state <= WAIT_FOR_STOP;
                end
            end
            WAIT_FOR_STOP: begin
                if (in == 1'b1) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= WAIT_FOR_STOP;
                end
            end
            default: next_state <= IDLE;
        endcase
        if (state == IDLE || state == START || state == DATA || state == WAIT_FOR_STOP) begin
            done <= 1'b0;
        end
    end
end

endmodule