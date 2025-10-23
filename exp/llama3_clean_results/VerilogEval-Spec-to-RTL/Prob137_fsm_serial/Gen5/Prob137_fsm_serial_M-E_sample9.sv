module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [1:0] state; // 2-bit state register (IDLE, START, DATA, STOP)
reg [2:0] counter; // 3-bit counter to keep track of data bits
reg start_bit; // Register to store the start bit
reg [7:0] data; // 8-bit register to store the data bits

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset state (IDLE)
        counter <= 3'b0; // Reset counter
        start_bit <= 1'b0; // Reset start bit
        data <= 8'b0; // Reset data
        done <= 1'b0; // Reset done signal
    end else begin
        case(state)
            2'b00: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 2'b01; // Transition to START state
                    start_bit <= in; // Store the start bit
                end
            end
            2'b01: begin // START state
                if (~in) begin // Start bit verified
                    state <= 2'b10; // Transition to DATA state
                end else begin
                    state <= 2'b00; // Transition back to IDLE state
                end
            end
            2'b10: begin // DATA state
                if (counter < 8) begin
                    data <= {data[6:0], in}; // Shift in new data bit
                    counter <= counter + 1; // Increment counter
                end
                if (counter == 8) begin // 8 data bits received
                    state <= 2'b11; // Transition to STOP state
                end
            end
            2'b11: begin // STOP state
                if (in) begin // Stop bit verified
                    done <= 1'b1; // Set done signal high
                    state <= 2'b00; // Transition to IDLE state
                end else begin
                    state <= 2'b10; // Transition back to DATA state
                end
                counter <= 3'b0; // Reset counter
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule