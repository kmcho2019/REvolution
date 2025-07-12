module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

// States for the finite state machine
parameter IDLE = 0, START = 1, DATA = 2, STOP = 3, ERROR = 4;

// Current state
reg [1:0] state;
reg [1:0] nextState;

// Counter for data bits
reg [2:0] dataBitCount;

// Shift register for data bits
reg [7:0] dataBits;

// Flag to indicate when a byte is received
reg byteReceived;

// Output to indicate when a byte is received
assign done = byteReceived;

// Reset state
initial state = IDLE;
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        dataBitCount <= 0;
        dataBits <= 8'b0;
        byteReceived <= 0;
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
                nextState <= DATA;
                dataBits[0] <= in;
                dataBitCount <= 1;
            end
            DATA: begin
                if (dataBitCount == 8) begin
                    nextState <= STOP;
                end else begin
                    nextState <= DATA;
                end
                dataBits[dataBitCount] <= in;
                dataBitCount <= dataBitCount + 1;
            end
            STOP: begin
                if (in) begin
                    nextState <= IDLE;
                    byteReceived <= 1;
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

// Clear byteReceived flag
always @(posedge clk) begin
    if (state == IDLE || state == ERROR) begin
        byteReceived <= 0;
    end
end

endmodule