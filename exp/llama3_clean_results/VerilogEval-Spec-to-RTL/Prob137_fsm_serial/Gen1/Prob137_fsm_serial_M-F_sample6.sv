module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// States for the finite state machine
parameter IDLE = 0, START = 1, DATA = 2, STOP = 3, ERROR = 4;

// Current state
reg [2:0] state;
reg [2:0] nextState;

// Counter for data bits
reg [3:0] dataBitCount;

// Shift register for data bits
reg [7:0] dataBits;

// Reset state
initial state = IDLE;
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        dataBitCount <= 0;
        dataBits <= 8'b0;
        done <= 0;
    end else begin
        state <= nextState;
        case(state)
            IDLE: begin
                if (!in) begin
                    nextState <= START;
                end else begin
                    nextState <= IDLE;
                end
            end
            START: begin
                if (in) begin
                    nextState <= ERROR;
                end else begin
                    nextState <= DATA;
                    dataBits[0] <= in;
                    dataBitCount <= 1;
                end
            end
            DATA: begin
                if (dataBitCount == 8) begin
                    nextState <= STOP;
                end else begin
                    nextState <= DATA;
                end
                dataBits[dataBitCount - 1] <= in;
                dataBitCount <= dataBitCount + 1;
            end
            STOP: begin
                if (in) begin
                    nextState <= IDLE;
                    done <= 1;
                end else begin
                    nextState <= ERROR;
                end
            end
            ERROR: begin
                if (in) begin
                    nextState <= IDLE;
                end else begin
                    nextState <= ERROR;
                end
            end
        endcase
    end
end

// Clear done flag
always @(posedge clk) begin
    if (state == START) begin
        done <= 0;
    end
end

endmodule