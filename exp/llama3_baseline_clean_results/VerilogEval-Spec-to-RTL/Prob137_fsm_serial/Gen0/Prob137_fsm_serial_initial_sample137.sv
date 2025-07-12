module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP, 4: ERROR
reg [2:0] bit_count; // Counter for data bits
reg [7:0] data; // Register to store the received data

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        bit_count <= 0;
        data <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // Start bit detected
                    state <= 1; // START
                end
            end
            1: begin // START
                state <= 2; // DATA
                bit_count <= 0;
            end
            2: begin // DATA
                data[bit_count] <= in; // Store the current bit
                if (bit_count == 7) begin
                    state <= 3; // STOP
                end else begin
                    bit_count <= bit_count + 1;
                end
            end
            3: begin // STOP
                if (in) begin // Stop bit verified
                    state <= 0; // IDLE
                    done <= 1; // Indicate byte received
                end else begin
                    state <= 4; // ERROR
                end
            end
            4: begin // ERROR
                if (in) begin // Stop bit detected
                    state <= 0; // IDLE
                end
            end
            default: state <= 0; // IDLE
        endcase
    end
end

always @(posedge clk) begin
    if (!reset) begin
        if (state == 0 && bit_count == 0) begin // Only reset done when in IDLE
            done <= 0;
        end
    end
end

endmodule