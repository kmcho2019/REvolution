module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
parameter STATE_A = 1'b0;
parameter STATE_B = 1'b1;

reg state; // 1-bit state variable
reg [1:0] window_counter; // 2-bit counter for three clock cycles
reg [1:0] w_count; // 2-bit signal to track w occurrences
reg temp_w_count; // Temporary variable to hold w_count at the end of each window

// Sequential logic for state and counters
always @(posedge clk) begin
    if(reset) begin
        state <= STATE_A; // Reset to state A
        window_counter <= 2'b00;
        w_count <= 2'b00;
        z <= 1'b0; // Reset output z
        temp_w_count <= 1'b0;
    end else begin
        case(state)
            STATE_A: begin
                if(s) begin
                    state <= STATE_B;
                    window_counter <= 2'b00;
                    w_count <= 2'b00;
                    temp_w_count <= 1'b0;
                end
            end
            STATE_B: begin
                if(window_counter == 2'b11) begin // At the end of the window
                    window_counter <= 2'b00; // Reset window counter
                    temp_w_count <= (w_count == 2'b10) ? 1'b1 : 1'b0; // Hold w_count for evaluation
                    w_count <= 2'b00; // Reset w_count for the next window
                    if(temp_w_count) begin
                        z <= 1'b1; // Set z high if w occurred exactly twice in the previous window
                    end else begin
                        z <= 1'b0;
                    end
                end else begin
                    window_counter <= window_counter + 1'b1; // Increment window counter
                    if(w) begin
                        if(w_count == 2'b10) begin
                            // Do nothing, w_count is already at its maximum value
                        end else begin
                            w_count <= w_count + 1'b1; // Increment w_count if w is high
                        end
                    end
                end
            end
        endcase
    end
end

endmodule