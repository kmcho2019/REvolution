module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] state; // 3-bit state register for the FSM
reg [7:0] parallel_out; // Parallel output register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the FSM and the parallel output register
        state <= 3'b000;
        parallel_out <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // Idle state
                if (din_valid) begin
                    // Transition to the data collection state
                    state <= 3'b001;
                    parallel_out <= {7'b0000000, din_serial};
                end else begin
                    // Stay in the idle state
                    state <= 3'b000;
                end
            end
            3'b001, 3'b010, 3'b011, 3'b100, 3'b101, 3'b110, 3'b111: begin // Data collection state
                if (din_valid) begin
                    // Shift in the new data and increment the state
                    parallel_out <= {parallel_out[6:0], din_serial};
                    state <= state + 1'b1;
                    if (state == 3'b111) begin
                        // Output is valid when 8 bits have been collected
                        dout_valid <= 1'b1;
                    end else begin
                        dout_valid <= 1'b0;
                    end
                end else begin
                    // Stay in the current state if no new data is available
                    state <= state;
                end
            end
            default: begin
                // Should never reach this state
                state <= 3'b000;
            end
        endcase
        // Update the output only when the FSM is in the data collection state
        if (state != 3'b000) begin
            dout_parallel <= parallel_out;
        end else begin
            dout_parallel <= 8'b00000000;
        end
    end
end

endmodule