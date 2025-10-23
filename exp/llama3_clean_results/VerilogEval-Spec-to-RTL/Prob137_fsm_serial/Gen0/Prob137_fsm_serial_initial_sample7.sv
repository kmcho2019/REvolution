module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // 0: IDLE, 1: START_BIT, 2: DATA_BITS, 3: STOP_BIT, 4: WAIT_STOP
reg [2:0] data_count; // Counts the 8 data bits
reg [7:0] data_byte; // Stores the received data byte

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE state
        data_count <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (~in) begin // Start bit detected
                    state <= 1; // START_BIT
                    data_count <= 1;
                end
            end
            1: begin // START_BIT
                state <= 2; // DATA_BITS
            end
            2: begin // DATA_BITS
                if (data_count == 8) begin
                    state <= 3; // STOP_BIT
                end else begin
                    data_count <= data_count + 1;
                end
            end
            3: begin // STOP_BIT
                if (in) begin // Stop bit correct
                    state <= 0; // IDLE
                    done <= 1; // Set done signal high
                end else begin
                    state <= 4; // WAIT_STOP
                end
            end
            4: begin // WAIT_STOP
                if (in) begin // Stop bit detected
                    state <= 0; // IDLE
                end
            end
            default: begin
                state <= 0; // IDLE
            end
        endcase
    end
end

always @(negedge clk) begin
    if (~reset) begin
        case (state)
            2: begin // DATA_BITS
                // data_byte <= {data_byte[6:0], in}; // MSB first
                // Since we are receiving the least significant bit first
                data_byte <= {data_byte[6:0], in};
            end
            3: begin // STOP_BIT
                done <= 0; // Reset done signal
            end
            default: begin
                done <= 0; // Reset done signal
            end
        endcase
    end
end

endmodule