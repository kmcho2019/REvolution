module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [1:0] state; // 2-bit state register
reg [3:0] counter; // 4-bit counter
reg [7:0] data; // 8-bit data register
reg filter_out; // Filter output

// Digital filter (moving average)
reg [1:0] filter_reg;
always @(posedge clk) begin
    if (reset) begin
        filter_reg <= 2'b0;
    end else begin
        filter_reg <= {filter_reg[0], in};
    end
end

assign filter_out = (filter_reg[0] && filter_reg[1]) || (!filter_reg[0] && !filter_reg[1]);

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to IDLE state
        counter <= 4'b0; // Reset counter
        data <= 8'b0; // Reset data register
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (!in && filter_out) begin // Start bit detected
                    state <= 2'b01; // Move to START state
                end
            end
            2'b01: begin // START state
                state <= 2'b10; // Move to RECEIVE state
            end
            2'b10: begin // RECEIVE state
                data <= {data[6:0], in}; // Shift in new bit
                counter <= counter + 1; // Increment counter
                if (counter == 8) begin // 8 bits received
                    state <= 2'b11; // Move to STOP state
                end
            end
            2'b11: begin // STOP state
                if (in && filter_out) begin // Stop bit verified
                    done <= 1'b1; // Set done signal high
                    state <= 2'b00; // Move back to IDLE state
                end else begin
                    state <= 2'b00; // Move back to IDLE state (error handling)
                end
                counter <= 4'b0; // Reset counter
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule