module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

// Define the states
enum logic [1:0] {
    IDLE,
    START,
    DATA,
    STOP
} state, next_state;

// Data register to store the received byte
logic [7:0] data;
logic [2:0] counter;

// Combinational logic to determine the next state
always_comb begin
    case(state)
        IDLE: begin
            if (!in) begin  // Start bit detected
                next_state = START;
            end else begin
                next_state = IDLE;
            end
        end
        START: begin
            next_state = DATA;
        end
        DATA: begin
            if (counter == 7) begin  // 8 data bits received
                next_state = STOP;
            end else begin
                next_state = DATA;
            end
        end
        STOP: begin
            if (in) begin  // Stop bit detected
                next_state = IDLE;
            end else begin
                next_state = STOP;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic to update the state and data register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        counter <= 3'b0;
    end else begin
        state <= next_state;
        case(state)
            START: begin
                data[0] <= in;  // Store the least significant bit first
            end
            DATA: begin
                data[counter + 1] <= in;  // Shift in the data bits
                counter <= counter + 1;
            end
            STOP: begin
                if (in) begin  // Stop bit detected, reset the counter
                    counter <= 3'b0;
                    done <= 1'b1;  // Set the done signal high
                end else begin
                    counter <= 3'b0;  // Reset the counter if stop bit is not detected
                end
            end
            default: begin
                counter <= 3'b0;
                done <= 1'b0;
            end
        endcase
    end
end

endmodule