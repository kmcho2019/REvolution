module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg done = 0
);

reg [2:0] state = 3'b000; // 3 states: IDLE (3'b000), START_BIT (3'b001), DATA_BITS (3'b010), STOP_BIT (3'b011)
reg [2:0] counter = 3'b000; // Counter for data bits
reg [7:0] data = 8'b00000000; // Received data byte

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // IDLE state
        counter <= 3'b000;
        done <= 0;
    end
    else begin
        case (state)
            3'b000: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 3'b001; // Transition to START_BIT state
                    counter <= 3'b000;
                    data <= 8'b00000000;
                end
            end
            3'b001: begin // START_BIT state
                state <= 3'b010; // Transition to DATA_BITS state
            end
            3'b010: begin // DATA_BITS state
                data <= {data[6:0], in}; // Shift data bits
                counter <= counter + 1;
                if (counter == 3'b1000) begin // 8 data bits received
                    state <= 3'b011; // Transition to STOP_BIT state
                end
            end
            3'b011: begin // STOP_BIT state
                if (in) begin // Stop bit correct
                    done <= 1; // Signal that a byte has been received
                    state <= 3'b000; // Return to IDLE state
                end
                else begin // Stop bit incorrect
                    state <= 3'b000; // Wait for a stop bit
                end
            end
            default: state <= 3'b000; // Return to IDLE state for invalid states
        endcase
    end
end

always @(negedge clk) begin
    done <= 0; // Reset done signal
end

endmodule