module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

reg [1:0] state; // 0 - State A, 1 - State B
reg [1:0] cycle_counter; // Counter for the 3 clock cycles
reg w_counter; // Counter for the number of w=1 in 3 cycles

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset to State A
        cycle_counter <= 0;
        w_counter <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Move to State B
                    cycle_counter <= 1; // Initialize cycle counter
                    w_counter <= 0; // Reset w counter
                end else begin
                    state <= 0; // Stay in State A
                end
                z <= 0; // z is 0 in State A
            end
            1: begin // State B
                if(cycle_counter < 3) begin // Checking cycles
                    cycle_counter <= cycle_counter + 1;
                    if(w) begin
                        w_counter <= w_counter + 1;
                    end
                end else begin // After 3 cycles
                    if(w_counter == 2) begin // Exactly 2 w=1 in 3 cycles
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    state <= 1; // Stay in State B for continuous checking
                    cycle_counter <= 1; // Reset cycle counter
                    w_counter <= 0; // Reset w counter
                end
            end
        endcase
    end
end

endmodule