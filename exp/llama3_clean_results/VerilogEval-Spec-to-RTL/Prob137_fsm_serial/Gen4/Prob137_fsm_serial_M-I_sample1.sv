module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// States for the finite state machine
enum logic [1:0] {IDLE, START, DATA, STOP} state;

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
                    state <= START;
                end
            end
            START: begin
                if (!in) begin
                    state <= DATA;
                    dataBitCount <= 0;
                end else begin
                    state <= IDLE;
                end
            end
            DATA: begin
                dataBits[dataBitCount] <= in;
                if (dataBitCount == 7) begin
                    state <= STOP;
                end else begin
                    state <= DATA;
                    dataBitCount <= dataBitCount + 1;
                end
            end
            STOP: begin
                if (in) begin
                    // Stop bit verified, set byteReceived flag
                    byteReceived <= 1;
                    state <= IDLE;
                    dataBitCount <= 0;
                    dataBits <= 8'b0;
                end else begin
                    // Stop bit not verified, stay in STOP state
                    state <= STOP;
                end
            end
        endcase
    end
end

// Output logic
always @(posedge clk) begin
    if (state == IDLE && byteReceived) begin
        done <= 1;
        byteReceived <= 0;
    end else begin
        done <= 0;
    end
end

endmodule