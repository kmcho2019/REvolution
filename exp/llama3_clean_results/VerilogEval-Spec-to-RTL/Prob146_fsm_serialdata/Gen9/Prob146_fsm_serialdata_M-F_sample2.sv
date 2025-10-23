module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state;
reg [7:0] data;
reg [2:0] bit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        data <= 8'b0;
        bit_counter <= 0;
        done <= 0;
    end
    else begin
        case(state)
: begin // IDLE
                if (!in) begin // Start bit detected
                    state <= 1; // Transition to START state
                    bit_counter <= 0;
                end
                else begin // Wait for start bit
                    done <= 0;
                end
            end
            1: begin // START
                state <= 2; // Move to DATA state
            end
            2: begin // DATA
                data <= {data[6:0], in}; // Shift data bits
                bit_counter <= bit_counter + 1;
                if (bit_counter == 3'd7) begin // 8 bits received
                    state <= 3; // Transition to STOP state
                end
            end
            3: begin // STOP
                if (in) begin // Stop bit verification
                    done <= 1; // Assert done signal
                    out_byte <= data; // Update out_byte
                end
                else begin // Incorrect stop bit, wait for stop bit
                    done <= 0;
                end
                if (in) begin // Stop bit detected, reset to IDLE
                    state <= 0;
                    bit_counter <= 0;
                    data <= 8'b0;
                end
            end
            default: begin
                state <= 0; // Ensure IDLE state on any other condition
            end
        endcase
        if (state != || !in) begin // Reset done signal when not in STOP state with correct stop bit
            done <= 0;
        end
    end
end

endmodule