module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] counter; // Counter for 3 cycles
reg [1:0] pulse_count; // Count of w=1 in 3 cycles
reg state; // State A (0) or State B (1)

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset to state A
        counter <= 0;
        pulse_count <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Move to State B
                    counter <= 1; // Start counting cycles in State B
                    pulse_count <= w? 1 : 0; // Initialize pulse count
                end
            end
            1: begin // State B
                if(counter < 3) begin
                    counter <= counter + 1; // Increment cycle counter
                    if(w) pulse_count <= pulse_count + 1; // Increment w pulse count if w=1
                end else begin
                    z <= (pulse_count == 2)? 1 : 0; // Set z based on pulse count
                    counter <= 1; // Reset counter for next window
                    pulse_count <= w? 1 : 0; // Reset pulse count
                end
            end
        endcase
    end
end

endmodule