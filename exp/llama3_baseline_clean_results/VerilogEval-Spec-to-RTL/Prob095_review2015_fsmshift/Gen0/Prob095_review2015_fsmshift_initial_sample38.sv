module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 2 states: RESET (0) and RUN (1)
reg [1:0] counter; // counter to keep track of clock cycles
reg shift_ena_reg; // internal signal for shift_ena

// Initialize state and counter
initial begin
    state = 2'b00; // RESET state
    counter = 2'b00;
    shift_ena_reg = 1'b0;
end

always @(posedge clk) begin
    if (reset) begin // Synchronous reset
        state = 2'b00; // Go to RESET state
        counter = 2'b00; // Reset counter
        shift_ena_reg = 1'b1; // Assert shift_ena
    end else begin
        case (state)
            2'b00: begin // RESET state
                if (counter == 4'd3) begin // After 4 cycles
                    state = 2'b01; // Transition to RUN state
                    counter = 2'b00; // Reset counter
                    shift_ena_reg = 1'b0; // De-assert shift_ena
                end else begin
                    counter = counter + 1'b1; // Increment counter
                end
            end
            2'b01: begin // RUN state
                // Do nothing, just stay in this state
            end
            default: begin
                state = 2'b00; // Go to RESET state in case of invalid state
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule