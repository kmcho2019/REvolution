module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// One-hot encoding for states
// idle: 001, rising edge: 010, falling edge: 100
reg [2:0] state; // Register to store the current state

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 3'b001; // Initial state: idle
        data_out <= 1'b0;
    end else begin
        case (state)
            3'b001: begin // Idle state
                if (data_in) begin // 0 to 1 transition
                    state <= 3'b010; // Move to rising edge state
                end else begin
                    state <= 3'b001; // Stay in idle state
                end
                data_out <= 1'b0;
            end
            
            3'b010: begin // Rising edge state
                if (data_in) begin // Stay in rising edge state
                    state <= 3'b010;
                end else begin // 1 to 0 transition
                    state <= 3'b100; // Move to falling edge state
                end
                data_out <= 1'b0;
            end
            
            3'b100: begin // Falling edge state
                state <= 3'b001; // Return to idle state
                data_out <= 1'b1; // Output pulse signal
            end
            
            default: begin
                state <= 3'b001;
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule