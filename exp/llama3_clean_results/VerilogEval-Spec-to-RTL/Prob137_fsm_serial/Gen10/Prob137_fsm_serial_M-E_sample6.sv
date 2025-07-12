module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data; // 8-bit register to store received data
reg [2:0] state; // 3-bit state register (IDLE, START, RECEIVE, STOP)
reg [3:0] count; // 4-bit counter to keep track of received bits

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset state to IDLE
        count <= 4'b0; // Reset counter
        data <= 8'b0; // Reset data register
        done <= 1'b0; // Reset done signal
    end else begin
        case(state)
            3'b000: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 3'b001; // Transition to START state
                    count <= 4'b1; // Increment counter
                end
            end
            3'b001: begin // START state
                state <= 3'b010; // Transition to RECEIVE state
            end
            3'b010: begin // RECEIVE state
                data <= {data[6:0], in}; // Shift in new bit
                count <= count + 1; // Increment counter
                if (count == 8) begin // 8 data bits received
                    state <= 3'b011; // Transition to STOP state
                end
            end
            3'b011: begin // STOP state
                if (in) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                end
                state <= 3'b000; // Transition to IDLE state
                count <= 4'b0; // Reset counter
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule