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

// Sequential logic for state and counters
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 1'b0; // Reset to state A
        window_counter <= 2'b00;
        w_count <= 2'b00;
    end else begin
        if(state == 1'b0) begin
            if(s) begin
                state <= 1'b1;
                window_counter <= 2'b00;
                w_count <= 2'b00;
            end
        end else begin
            if(window_counter == 2'b11) begin
                window_counter <= 2'b00;
                w_count <= 2'b00; // Reset w_count for the next window
            end else begin
                window_counter <= window_counter + 1'b1;
                if(w) begin
                    w_count <= w_count + 1'b1;
                end
            end
        end
    end
end

// Combinational logic for output z
always @(posedge clk) begin
    if(state == 1'b1 && window_counter == 2'b11) begin
        if(w_count == 2'b10) begin // Check if w occurred exactly twice
            z <= 1'b1;
        end else begin
            z <= 1'b0;
        end
    end
end

endmodule