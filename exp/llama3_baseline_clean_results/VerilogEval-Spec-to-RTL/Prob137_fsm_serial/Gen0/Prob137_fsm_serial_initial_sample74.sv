module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE,
    START_BIT,
    DATA_BITS,
    STOP_BIT,
    ERROR
} state, next_state;

// Counter for data bits
reg [3:0] data_bit_count;

always @(*) begin
    // Default values
    next_state = state;
    done = 1'b0;

    case (state)
        IDLE: begin
            if (in == 1'b0) begin
                // Start bit detected, move to START_BIT state
                next_state = START_BIT;
            end
            else begin
                // Stay in IDLE state
                next_state = IDLE;
            end
        end

        START_BIT: begin
            // Move to DATA_BITS state
            next_state = DATA_BITS;
        end

        DATA_BITS: begin
            if (data_bit_count == 8) begin
                // All data bits received, move to STOP_BIT state
                next_state = STOP_BIT;
            end
            else begin
                // Stay in DATA_BITS state
                next_state = DATA_BITS;
            end
        end

        STOP_BIT: begin
            if (in == 1'b1) begin
                // Stop bit verified, assert done and move to IDLE state
                done = 1'b1;
                next_state = IDLE;
            end
            else begin
                // Stop bit not verified, move to ERROR state
                next_state = ERROR;
            end
        end

        ERROR: begin
            if (in == 1'b1) begin
                // Stop bit detected, move to IDLE state
                next_state = IDLE;
            end
            else begin
                // Stay in ERROR state
                next_state = ERROR;
            end
        end

    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_bit_count <= 4'b0;
    end
    else begin
        state <= next_state;
        if (state == DATA_BITS) begin
            data_bit_count <= data_bit_count + 1'b1;
        end
        else begin
            data_bit_count <= 4'b0;
        end
    end
end

endmodule