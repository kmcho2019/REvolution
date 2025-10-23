module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Parameters
parameter DATA_BITS = 8;

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b001,
    START = 3'b010,
    DATA = 3'b011,
    STOP = 3'b100,
    ERROR = 3'b101
} state;

// Data bits counter
reg [$clog2(DATA_BITS)-1:0] data_counter;

// Received data bits
reg [DATA_BITS-1:0] data;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_counter <= 0;
        data <= 0;
        done <= 0;
    end else begin
        case(state)
            IDLE: begin
                if (~in) begin // Start bit detected
                    state <= START;
                end
            end
            START: begin
                state <= DATA;
                data_counter <= 0;
                data <= 0;
            end
            DATA: begin
                data_counter <= data_counter + 1;
                data <= {data[DATA_BITS-2:0], in}; // Shift data and add new bit
                if (data_counter == DATA_BITS - 1) begin // All data bits received
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin // Stop bit detected
                    state <= IDLE;
                    done <= 1;
                end else begin
                    state <= ERROR;
                end
            end
            ERROR: begin
                if (in) begin // Stop bit detected, now idle
                    state <= IDLE;
                end
            end
        endcase
        if (state == IDLE && state != START) begin
            done <= 0;
        end
    end
end

endmodule