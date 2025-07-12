module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: START, 2: RECEIVE, 3: STOP
reg [2:0] bit_counter;
reg [7:0] data;

// Sequential logic
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE state
        bit_counter <= 0;
        data <= 8'b0;
        done <= 0;
    end
    else begin
        case(state)
            0: begin // IDLE
                if (!in) begin
                    state <= 1; // Transition to START state on start bit
                end
            end
            1: begin // START
                state <= 2; // Transition to RECEIVE state
                bit_counter <= 0;
            end
            2: begin // RECEIVE
                data <= {in, data[7:1]}; // Shift in data bits
                bit_counter <= bit_counter + 1;
                if (bit_counter == 3'd7) begin // 8 bits received
                    state <= 3; // Transition to STOP state
                end
            end
            3: begin // STOP
                if (in) begin // Correct stop bit
                    done <= 1; // Assert done signal
                    out_byte <= data; // Update out_byte
                    state <= 0; // Reset to IDLE state
                end
                else begin // Incorrect stop bit, wait for stop bit
                    state <= 3; // Stay in STOP state
                end
            end
            default: begin
                state <= 0; // Ensure IDLE state on any other condition
            end
        endcase
    end
end

// Combinational logic
always_comb begin
    if (state == 3 && !in) begin
        done = 0; // Reset done signal if in STOP state and in is not high
    end
end

endmodule