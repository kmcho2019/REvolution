module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// States for the finite state machine
enum logic [1:0] {IDLE, START, DATA, STOP} state, nextState;

// Counter for data bits
reg [2:0] dataBitCount;

// Shift register for data bits
reg [7:0] dataBits;

// Flag to indicate when a byte is received
reg byteReceived;

// Initialize state
initial state = IDLE;

// State machine
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        dataBitCount <= 0;
        dataBits <= 8'b0;
        byteReceived <= 0;
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
                // Verify start bit
                if (!in) begin
                    nextState = DATA;
                    dataBitCount <= 0;
                end else begin
                    nextState = IDLE;
                end
            end
            DATA: begin
                dataBits[dataBitCount] <= in;
                if (dataBitCount == 7) begin
                    nextState = STOP;
                end else begin
                    nextState = DATA;
                    dataBitCount <= dataBitCount + 1;
                end
            end
            STOP: begin
                if (in) begin
                    // Stop bit verified, set byteReceived flag
                    byteReceived <= 1;
                    nextState = IDLE;
                    dataBitCount <= 0;
                    dataBits <= 8'b0;
                end else begin
                    // Stop bit not verified, stay in STOP state
                    nextState = STOP;
                end
            end
        endcase
        state <= nextState;
    end
end

// Output logic
assign done = byteReceived;

// Clear byteReceived flag when transitioning from STOP to IDLE
always @(posedge clk) begin
    if (state == STOP && nextState == IDLE) begin
        byteReceived <= 0;
    end
end

endmodule