module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Define states
parameter IDLE = 0, START = 1, DATA = 2, STOP = 3, ERROR = 4;

// Current state and next state
reg [2:0] state;
reg [2:0] nextState;

// Counter for data bits
reg [2:0] dataBitCount;

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
        case(state)
            IDLE: begin
                if (!in) begin
                    nextState = START;
                end else begin
                    nextState = IDLE;
                end
            end
            START: begin
                if (in) begin
                    nextState = ERROR;
                end else begin
                    nextState = DATA;
                    dataBits[0] = in;
                    dataBitCount = 1;
                end
            end
            DATA: begin
                if (dataBitCount == 7) begin
                    nextState = STOP;
                end else begin
                    nextState = DATA;
                end
                dataBits[dataBitCount] = in;
                dataBitCount = dataBitCount + 1;
            end
            STOP: begin
                if (in) begin
                    nextState = IDLE;
                    done = 1;
                end else begin
                    nextState = ERROR;
                end
            end
            ERROR: begin
                if (in) begin
                    nextState = IDLE;
                    done = 0;
                end else begin
                    nextState = ERROR;
                end
            end
        endcase
        state <= nextState;
    end
end

endmodule