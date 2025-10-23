module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

// States for the finite state machine
parameter IDLE = 2'b00, START = 2'b01, STOP = 2'b10;

// Current state
reg [1:0] state;

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
        case(state)
            IDLE: begin
                if (!in) begin
                    state <= START;
                end
            end
            START: begin
                dataBits[dataBitCount] <= in;
                if (dataBitCount == 7) begin
                    state <= STOP;
                end else begin
                    dataBitCount <= dataBitCount + 1;
                end
            end
            STOP: begin
                if (in) begin
                    byteReceived <= 1;
                    state <= IDLE;
                    dataBitCount <= 0;
                end else begin
                    state <= STOP;
                end
            end
        endcase
    end
end

// Clear byteReceived flag
always @(posedge clk) begin
    if (state == IDLE) begin
        byteReceived <= 0;
    end
end

endmodule