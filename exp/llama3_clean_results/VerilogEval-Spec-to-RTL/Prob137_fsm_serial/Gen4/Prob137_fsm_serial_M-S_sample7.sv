module TopModule (
    input        clk,
    input        reset,
    input        in,
    output       done
);

reg [2:0] state; // 0: Idle, 1: Data, 2: Stop
reg [7:0] data; // Collected data bits
reg [3:0] counter; // Counter for data bits
reg done_reg;

always @(posedge clk) begin
    if (reset) begin // Synchronous reset
        state <= 0; // Reset to Idle state
        counter <= 0;
        data <= 8'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            0: begin // Idle state
                if (!in) begin // Detect start bit
                    state <= 1;
                    counter <= 1;
                    data <= {7'b0, 1'b0}; // Start collecting data bits
                end
            end
            1: begin // Data state
                data <= {data[6:0], in}; // Collect data bits, least significant bit first
                counter <= counter + 1;
                if (counter == 9) begin
                    state <= 2;
                end
            end
            2: begin // Stop state
                if (in) begin // Verify stop bit
                    done_reg <= 1'b1; // Signal byte reception
                    state <= 0; // Correct stop bit, go back to Idle
                end 
            end
        endcase
    end
end

assign done = done_reg;

endmodule