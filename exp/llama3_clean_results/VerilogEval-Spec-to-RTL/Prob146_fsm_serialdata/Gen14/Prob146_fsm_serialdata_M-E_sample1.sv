module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [7:0] data_buffer; // Buffer for shifting in data bits
reg [2:0] state; // 0: IDLE, 1: START, 2: RECEIVE, 3: STOP
reg [2:0] bit_counter;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE state
        bit_counter <= 0;
        data_buffer <= 8'b0;
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
                data_buffer <= {in, data_buffer[7:1]}; // Shift in data bits (LSB first)
                bit_counter <= bit_counter + 1;
                if (bit_counter == 3'd7) begin // 8 bits received
                    state <= 3; // Transition to STOP state
                end
            end
            3: begin // STOP
                if (in) begin // Correct stop bit
                    out_byte <= data_buffer; // Transfer received byte to out_byte
                    done <= 1; // Assert done signal
                end
                state <= 0; // Reset to IDLE state
                data_buffer <= 8'b0; // Reset data_buffer
            end
            default: begin
                state <= 0; // Ensure IDLE state on any other condition
            end
        endcase
        if (state == 0) begin
            done <= 0; // Reset done signal in IDLE state
        end
    end
end

endmodule