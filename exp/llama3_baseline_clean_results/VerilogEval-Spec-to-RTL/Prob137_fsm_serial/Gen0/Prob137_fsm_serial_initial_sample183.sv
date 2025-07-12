module TopModule (
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [2:0] state; // 0: IDLE, 1: RECEIVE_DATA, 2: CHECK_STOP, 3: WAIT_FOR_STOP
reg [7:0] data; // Store the received data bits
reg [2:0] bit_count; // Counter for received data bits
reg done_reg; // Register for the done signal

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        data <= 8'b0;
        bit_count <= 3'b0;
        done_reg <= 1'b0;
    end
    else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // Start bit detected
                    state <= 1; // RECEIVE_DATA
                    bit_count <= 1'b1;
                    data[0] <= 1'b0; // Save the start bit in the least significant bit
                end
            end
            1: begin // RECEIVE_DATA
                data[bit_count] <= in; // Save the current bit
                if (bit_count == 8'b10000000) begin // 8 bits received
                    state <= 2; // CHECK_STOP
                end
                else begin
                    bit_count <= bit_count + 1'b1;
                end
            end
            2: begin // CHECK_STOP
                if (in) begin // Stop bit is 1
                    state <= 0; // IDLE
                    done_reg <= 1'b1;
                end
                else begin // Stop bit is not 1
                    state <= 3; // WAIT_FOR_STOP
                end
            end
            3: begin // WAIT_FOR_STOP
                if (in) begin // Stop bit detected
                    state <= 0; // IDLE
                end
            end
        endcase
        done <= done_reg;
        done_reg <= 1'b0; // Clear done signal after one clock cycle
    end
end

endmodule