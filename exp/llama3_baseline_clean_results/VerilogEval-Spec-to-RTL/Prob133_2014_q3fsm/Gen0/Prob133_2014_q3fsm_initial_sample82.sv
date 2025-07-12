module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State A (2'b00) and State B (2'b01), potentially more for counters
reg [1:0] counter; // Counts the number of w = 1 in the last three cycles
reg [1:0] clock_counter; // Counts the clock cycles since entering State B

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 2'b00; // Reset to State A
        counter <= 2'b00;
        clock_counter <= 2'b00;
        z <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // State A
                if(s) begin
                    state <= 2'b01; // Transition to State B
                    clock_counter <= 2'b01; // Start counting from the first cycle in State B
                end
            end
            2'b01: begin // State B
                if(clock_counter < 3'b100) begin // If within the 3 cycles
                    clock_counter <= clock_counter + 1'b1; // Increment clock counter
                    if(w) begin
                        counter <= counter + 1'b1; // Increment w counter if w = 1
                    end
                end else begin // After 3 cycles
                    if(counter == 2'b10) begin // If exactly two w = 1 in the last 3 cycles
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                    // Reset counters and prepare for next examination
                    counter <= 2'b00;
                    clock_counter <= 2'b01;
                end
            end
        endcase
    end
end

endmodule