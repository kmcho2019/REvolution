module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

// Define states for the FSM
enum logic [2:0] {IDLE, START, DATA, STOP} state, nextState;

// Registers to hold the current data and the count of bits received
logic [7:0] data;
logic [2:0] bitCount;

// Sequential logic for state transitions and data manipulation
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        bitCount <= 3'b0;
    end else begin
        case(state)
            IDLE: begin
                if (!in) begin // Start bit detected
                    state <= START;
                    data <= 8'b0;
                    bitCount <= 3'b0;
                end else begin
                    state <= IDLE;
                end
            end
            START: begin
                // Data bit received, shift it into the data register
                data[0] <= in;
                bitCount <= bitCount + 1;
                if (bitCount == 3'b1000) begin // 8 bits received
                    state <= STOP;
                end else begin
                    // Shift data bits for the next clock cycle
                    data <= {data[6:0], in};
                end
            end
            STOP: begin
                if (in) begin // Stop bit detected
                    state <= IDLE;
                    done <= 1'b1; // Assert 'done' signal
                end else begin
                    // Wait for the stop bit
                    state <= STOP;
                end
            end
            default: state <= IDLE;
        endcase;
    end
end

// Combinational logic to ensure 'done' is deasserted outside of STOP state
always_comb begin
    if (state != STOP || !in) begin
        done <= 1'b0;
    end
end

endmodule