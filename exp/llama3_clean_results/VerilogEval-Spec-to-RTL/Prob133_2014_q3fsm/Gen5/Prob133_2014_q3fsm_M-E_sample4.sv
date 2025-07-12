module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg state; // Single-bit state variable (0: State A, 1: State B)
reg [2:0] w_count; // 3-bit counter for w occurrences
reg [1:0] window_counter; // 2-bit counter for three clock cycles

// Sequential logic
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 1'b0; // Reset to state A
        w_count <= 3'b000;
        window_counter <= 2'b00;
        z <= 1'b0;
    end else begin
        if(state == 1'b0) begin // State A
            if(s) begin
                state <= 1'b1; // Transition to state B
                w_count <= 3'b000;
                window_counter <= 2'b01;
            end
        end else begin // State B
            if(window_counter == 2'b11) begin // End of three-clock-cycle window
                if(w_count == 3'b010) begin // Exactly two occurrences of w
                    z <= 1'b1;
                end else begin
                    z <= 1'b0;
                end
                w_count <= 3'b000;
                window_counter <= 2'b01;
            end else begin // Within three-clock-cycle window
                if(w) begin
                    w_count <= w_count + 1'b1;
                end
                window_counter <= window_counter + 1'b1;
            end
            if(~s) begin // Transition back to state A
                state <= 1'b0;
                w_count <= 3'b000;
                window_counter <= 2'b00;
                z <= 1'b0;
            end
        end
    end
end

endmodule