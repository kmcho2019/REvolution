module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Define top-level states
parameter IDLE = 0, START = 1, DATA = 2, STOP = 3, ERROR = 4;

// Define sub-state machine states for data bits reception
parameter DATA_IDLE = 0, DATA_RECEIVE = 1, DATA_DONE = 2;

// Current top-level state and next state
reg [2:0] topLevelState;
reg [2:0] nextTopLevelState;

// Current sub-state machine state and next state
reg [1:0] dataState;
reg [1:0] nextDataState;

// Counter for data bits
reg [2:0] dataBitCount;

// Shift register for data bits
reg [7:0] dataBits;

// Reset state
initial begin
    topLevelState = IDLE;
    dataState = DATA_IDLE;
    dataBitCount = 0;
    dataBits = 8'b0;
    done = 0;
end

always @(posedge clk) begin
    if (reset) begin
        topLevelState <= IDLE;
        dataState <= DATA_IDLE;
        dataBitCount <= 0;
        dataBits <= 8'b0;
        done <= 0;
    end else begin
        case(topLevelState)
            IDLE: begin
                if (!in) begin
                    nextTopLevelState = START;
                end else begin
                    nextTopLevelState = IDLE;
                end
            end
            START: begin
                if (in) begin
                    nextTopLevelState = ERROR;
                end else begin
                    nextTopLevelState = DATA;
                    dataState = DATA_RECEIVE;
                    dataBitCount = 1;
                    dataBits[0] = in;
                end
            end
            DATA: begin
                case(dataState)
                    DATA_RECEIVE: begin
                        if (dataBitCount == 7) begin
                            nextDataState = DATA_DONE;
                        end else begin
                            nextDataState = DATA_RECEIVE;
                        end
                        dataBits[dataBitCount] = in;
                        dataBitCount = dataBitCount + 1;
                    end
                    DATA_DONE: begin
                        nextDataState = DATA_DONE;
                    end
                endcase
                if (dataState == DATA_DONE) begin
                    nextTopLevelState = STOP;
                end else begin
                    nextTopLevelState = DATA;
                end
            end
            STOP: begin
                if (in) begin
                    nextTopLevelState = IDLE;
                    done = 1;
                end else begin
                    nextTopLevelState = ERROR;
                end
            end
            ERROR: begin
                if (in) begin
                    nextTopLevelState = IDLE;
                    done = 0;
                end else begin
                    nextTopLevelState = ERROR;
                end
            end
        endcase
        topLevelState <= nextTopLevelState;
        dataState <= nextDataState;
    end
end

endmodule