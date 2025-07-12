module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state; // 0: IDLE, 1: WAIT_START, 2: RECEIVE
reg [2:0] bit_counter;
reg [7:0] data;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        bit_counter <= 0;
        data <= 8'b0;
        done <= 0;
    end
    else begin
        case(state)
            0: begin // IDLE
                if (!in) begin
                    state <= 1; // Transition to WAIT_START state on start bit
                end
            end
            1: begin // WAIT_START
                state <= 2; // Transition to RECEIVE state
                bit_counter <= 0;
            end
            2: begin // RECEIVE
                data <= {data[6:0], in}; // Shift in data bits
                bit_counter <= bit_counter + 1;
                if (bit_counter == 3'd7) begin // 8 bits received
                    if (in) begin // Stop bit verification
                        done <= 1; // Assert done signal
                        out_byte <= data; // Update out_byte
                        state <= 0; // Transition to IDLE state
                    end
                    else begin // Incorrect stop bit, wait for stop bit
                        done <= 0;
                    end
                end
                else if (in) begin // Stop bit detected before 8 bits, wait for stop bit
                    done <= 0;
                end
            end
            default: begin
                state <= 0; // Ensure IDLE state on any other condition
            end
        endcase
        if (state!= 2 || bit_counter!= 3'd7 ||!in) begin // Reset done signal when not in RECEIVE state with correct stop bit
            done <= 0;
        end
    end
end

endmodule