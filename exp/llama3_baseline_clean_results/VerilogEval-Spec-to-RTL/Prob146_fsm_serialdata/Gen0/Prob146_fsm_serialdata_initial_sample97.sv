module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define the states
localparam IDLE = 4'b0000;
localparam START_BIT = 4'b0001;
localparam DATA_BITS = 4'b0010;
localparam STOP_BIT = 4'b0011;
localparam ERROR = 4'b0100;

// Current state
reg [3:0] current_state;
reg [3:0] next_state;

// Byte counter
reg [2:0] byte_counter;

// Data bit counter
reg [3:0] data_counter;

always @(*) begin
    // Default values
    next_state = current_state;
    done = 1'b0;

    case (current_state)
        IDLE: begin
            if (in == 1'b0) begin // Start bit detected
                next_state = START_BIT;
                data_counter = 4'b0000;
            end else begin // Still waiting for start bit
                next_state = IDLE;
            end
        end

        START_BIT: begin
            next_state = DATA_BITS;
        end

        DATA_BITS: begin
            if (data_counter == 4'b1000) begin // 8 bits received, waiting for stop bit
                next_state = STOP_BIT;
            end else begin // Still collecting data bits
                data_counter = data_counter + 4'b0001;
                next_state = DATA_BITS;
            end
        end

        STOP_BIT: begin
            if (in == 1'b1) begin // Stop bit detected
                next_state = IDLE;
                done = 1'b1;
            end else begin // Error, stop bit not detected
                next_state = ERROR;
            end
        end

        ERROR: begin
            if (in == 1'b1) begin // Stop bit detected, return to IDLE
                next_state = IDLE;
                done = 1'b1;
            end else begin // Still waiting for stop bit
                next_state = ERROR;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        out_byte <= 8'b00000000;
        byte_counter <= 3'b000;
        data_counter <= 4'b0000;
    end else begin
        current_state <= next_state;
        if (current_state == DATA_BITS) begin
            // Shift in the data bit
            out_byte <= {out_byte[6:0], in};
        end
    end
end