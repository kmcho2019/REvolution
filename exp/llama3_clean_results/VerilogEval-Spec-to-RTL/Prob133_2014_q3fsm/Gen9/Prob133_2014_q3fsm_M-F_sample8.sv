module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg state; // 1-bit state variable (0: State A, 1: State B)
reg [1:0] window_counter; // 2-bit counter for three clock cycles
reg [1:0] w_count; // 2-bit signal to track w occurrences
reg [1:0] temp_w_count; // Temporary variable to hold w_count at the end of each window

// Sequential logic for state and counters
always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0; // Reset to state A
        window_counter <= 2'b00;
        w_count <= 2'b00;
        z <= 1'b0; // Reset output z
        temp_w_count <= 2'b00;
    end else begin
        if(state == 1'b0) begin
            if(s) begin
                state <= 1'b1;
                window_counter <= 2'b00;
                w_count <= 2'b00;
                temp_w_count <= 2'b00;
            end
        end else begin
            if(window_counter == 2'b10) begin // At the end of the window
                window_counter <= 2'b00; // Reset window counter
                temp_w_count <= w_count; // Hold w_count for evaluation
                w_count <= 2'b00; // Reset w_count for the next window
            end else begin
                window_counter <= window_counter + 1'b1; // Increment window counter
                if(w) begin
                    w_count <= w_count + 1'b1; // Increment w_count if w is high
                end
            end
            // Evaluate temp_w_count to set z
            if(window_counter == 2'b00 && temp_w_count == 2'b10) begin
                z <= 1'b1; // Set z high if w occurred exactly twice in the previous window
            end else begin
                z <= 1'b0;
            end
        end
    end
end

endmodule