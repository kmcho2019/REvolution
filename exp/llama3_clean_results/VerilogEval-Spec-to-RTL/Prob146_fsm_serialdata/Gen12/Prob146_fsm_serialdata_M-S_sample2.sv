module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: RECEIVE
reg [:0] bit_counter;
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
                    state <= 1; // Transition to RECEIVE state on start bit
                    bit_counter <=;
                    data <= {'b0, in}; // Initialize data with start bit
                end
            end
            1: begin // RECEIVE
                data <= {data[6:0], in}; // Shift in data bits
                bit_counter <= bit_counter + 1;
                if (bit_counter == 'd8) begin // 8 bits received
                    if (in) begin // Stop bit verification
                        done <= 1; // Assert done signal
                        out_byte <= data[7:0]; // Update out_byte (excluding start bit)
                    end
                    state <= 0; // Transition to IDLE state
                end
            end
        endcase
        if (state == 0 || bit_counter != 3'd8 || !in) begin // Reset done signal when not in RECEIVE state with correct stop bit
            done <= 0;
        end
    end
end

endmodule