module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [2:0] data_bits; // Counter for data bits
reg [7:0] data; // Register to store received data

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        data_bits <= 0;
        data <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (~in) begin // Start bit detected
                    state <= 1;
                end
            end
            1: begin // START
                state <= 2; // Move to DATA state
                data_bits <= 0;
            end
            2: begin // DATA
                data_bits <= data_bits + 1;
                data[7 - data_bits] <= in; // Store data bit (LSB first)
                if (data_bits == 8) begin
                    state <= 3; // Move to STOP state
                end
            end
            3: begin // STOP
                if (in) begin // Stop bit detected
                    done <= 1;
                    state <= 0; // Move to IDLE state
                end // If stop bit is not detected, stay in STOP state
            end
        endcase
    end
end

always @(negedge clk) begin
    done <= 0; // Clear done signal at the end of the clock cycle
end

endmodule