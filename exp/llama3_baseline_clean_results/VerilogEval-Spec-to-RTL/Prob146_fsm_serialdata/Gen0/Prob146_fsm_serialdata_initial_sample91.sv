module TopModule(
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state; // 5 states: IDLE (0), START (1), DATA (2), STOP_WAIT (3), STOP_VALID (4)
reg [2:0] data_count; // Counter for data bits
reg [7:0] data_reg; // Register to hold the received data bits

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to IDLE state
        done <= 0;
        out_byte <= 8'd0;
        data_count <= 0;
        data_reg <= 8'd0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 1; // Move to START state
                end
            end
            1: begin // START state
                data_reg[0] <= in; // Store the first data bit
                state <= 2; // Move to DATA state
                data_count <= 1; // Initialize data count
            end
            2: begin // DATA state
                data_reg[data_count] <= in; // Store the current data bit
                data_count <= data_count + 1; // Increment data count
                if (data_count == 8) begin
                    state <= 3; // Move to STOP_WAIT state
                end
            end
            3: begin // STOP_WAIT state
                if (in) begin // Stop bit detected
                    state <= 4; // Move to STOP_VALID state
                end
            end
            4: begin // STOP_VALID state
                done <= 1; // Assert done signal
                out_byte <= data_reg; // Output the received byte
                state <= 0; // Move back to IDLE state
            end
        endcase
    end
end

always @(posedge clk) begin
    if (~reset) begin
        if (state == 4) begin // STOP_VALID state
            done <= 1; // Assert done signal for one clock cycle
        end else begin
            done <= 0; // Deassert done signal
        end
    end
end

endmodule