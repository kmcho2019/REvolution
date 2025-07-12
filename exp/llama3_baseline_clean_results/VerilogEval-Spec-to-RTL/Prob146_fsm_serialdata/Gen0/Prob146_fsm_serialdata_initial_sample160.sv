module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Enum for states
typedef enum logic [2:0] {
    IDLE,
    RECEIVING_BYTE,
    CHECK_STOP_BIT,
    WAIT_FOR_STOP_BIT
} state_t;

// Current state and next state
state_t current_state;
state_t next_state;

// Counter for bits received
logic [3:0] bit_counter;

// Register for received byte
logic [7:0] byte_register;

assign done = (current_state == CHECK_STOP_BIT && in == 1);

always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        bit_counter <= 0;
        byte_register <= 0;
        out_byte <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                if (!in) begin // Start bit detected
                    current_state <= RECEIVING_BYTE;
                    bit_counter <= 1;
                    byte_register <= {7'b0, in};
                end else begin
                    current_state <= IDLE;
                end
            end
            RECEIVING_BYTE: begin
                if (bit_counter < 8) begin
                    bit_counter <= bit_counter + 1;
                    byte_register <= {byte_register[6:0], in};
                    current_state <= RECEIVING_BYTE;
                end else begin
                    current_state <= CHECK_STOP_BIT;
                end
            end
            CHECK_STOP_BIT: begin
                if (in) begin // Stop bit detected
                    out_byte <= byte_register;
                    current_state <= IDLE;
                end else begin // Incorrect stop bit
                    current_state <= WAIT_FOR_STOP_BIT;
                end
            end
            WAIT_FOR_STOP_BIT: begin
                if (in) begin // Stop bit detected
                    current_state <= IDLE;
                end else begin
                    current_state <= WAIT_FOR_STOP_BIT;
                end
            end
        endcase
    end
end

endmodule