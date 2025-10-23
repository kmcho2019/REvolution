module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b001,
    START = 3'b010,
    DATA = 3'b011,
    STOP = 3'b100,
    ERROR = 3'b101
} state, next_state;

// Data bits counter
reg [2:0] data_counter;

// Received data bits
reg [7:0] data;

always @(*) begin
    next_state = state;
    case(state)
        IDLE: begin
            if (~in) begin // Start bit detected
                next_state = START;
            end
        end
        START: begin
            next_state = DATA;
        end
        DATA: begin
            if (data_counter == 8'd7) begin // All data bits received
                next_state = STOP;
            end
        end
        STOP: begin
            if (in) begin // Stop bit detected
                next_state = IDLE;
                done = 1'b1;
            end else begin
                next_state = ERROR;
            end
        end
        ERROR: begin
            if (in) begin // Stop bit detected, now idle
                next_state = IDLE;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_counter <= 3'b000;
        data <= 8'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;
        case(state)
            START: begin
                data_counter <= 3'b000;
                data <= 8'b0;
            end
            DATA: begin
                data_counter <= data_counter + 1'b1;
                data <= {data[6:0], in}; // Shift data and add new bit
            end
            IDLE: begin
                done <= 1'b0;
            end
            ERROR: begin
                done <= 1'b0;
            end
        endcase
    end
end

endmodule