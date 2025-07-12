module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg done // Declare done as a reg for procedural assignment
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

// Buffer for received data
logic [7:0] data_buf;

// Internal signal for done
logic done_int;

// Initialize the state and counter
initial state = IDLE;
initial data_count = 0;
initial done_int = 0;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_count <= 0;
        data_buf <= 0;
        done_int <= 0;
        done <= 0; // Reset done
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
                done_int <= 1; // Assert done_int for one clock cycle
            end
            default: begin
                data_count <= 0;
                data_buf <= 0;
                done_int <= 0;
            end
        endcase
        done <= done_int; // Assign done_int to done
        if (done_int) begin
            done_int <= 0; // De-assert done_int after one clock cycle
        end
    end
end

// Combinational logic for next_state
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

endmodule