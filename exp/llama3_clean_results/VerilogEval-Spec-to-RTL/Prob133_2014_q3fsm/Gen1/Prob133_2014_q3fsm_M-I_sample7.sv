module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // 0: State A, 1: State B
reg [1:0] counter; // Counter for 3 cycles
reg [1:0] pulse_count; // Count of w=1 in 3 cycles
reg z_reg; // Register for output z

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset to state A
        counter <= 0;
        pulse_count <= 0;
        z_reg <= 0;
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
                if(counter == 3) begin // End of 3-cycle window
                    z_reg <= (pulse_count == 2)? 1 : 0; // Set z based on pulse count
                    counter <= 1; // Reset counter for next window
                    pulse_count <= w? 1 : 0; // Reset pulse count
                end else begin
                    counter <= counter + 1; // Increment cycle counter
                    if(w) pulse_count <= pulse_count + 1; // Increment w pulse count if w=1
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule