module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

// Define states
enum logic [2:0] {
    IDLE,
    START,
    DATA,
    STOP,
    ERROR
} state, next_state;

// Counter for data bits
logic [2:0] data_count;

// Buffer for received data (not used in this example, but could be for further processing)
logic [7:0] data_buf;

// Initialize the state and counter
initial state = IDLE;
initial data_count = 0;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_count <= 0;
        data_buf <= 0;
    end else begin
        state <= next_state;
        case(state)
            START: begin
                data_buf[0] <= in; // Store the first data bit
                data_count <= 1;
            end
            DATA: begin
                data_buf[data_count] <= in; // Store the next data bit
                data_count <= data_count + 1;
            end
            STOP: begin
                data_count <= 0; // Reset data count for the next byte
            end
            default: begin
                data_count <= 0;
                data_buf <= 0;
            end
        endcase
    end
end

// Combinational logic
always_comb begin
    case(state)
        IDLE: begin
            if (!in) begin // Start bit received
                next_state = START;
            end else begin
                next_state = IDLE;
            end
        end
        START: begin
            next_state = DATA;
        end
        DATA: begin
            if (data_count == 8) begin
                next_state = STOP;
            end else begin
                next_state = DATA;
            end
        end
        STOP: begin
            if (in) begin // Stop bit received
                next_state = IDLE;
                done = 1'b1;
            end else begin
                next_state = ERROR;
            end
        end
        ERROR: begin
            if (in) begin // Wait for stop bit (or idle)
                next_state = IDLE;
            end else begin
                next_state = ERROR;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Assign done to 0 when not in the STOP state with a valid stop bit
always_comb begin
    if (state != STOP || !in) begin
        done = 1'b0;
    end
end

endmodule