module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Use binary encoding for states to reduce area and improve timing
reg [1:0] state, next_state;

// Define states
localparam IDLE = 2'b00;
localparam PEAK = 2'b01;
localparam FALLING = 2'b10;

always @(posedge clk) begin
    if (~rst_n) begin
        // Synchronous reset
        state <= IDLE; // Reset state to IDLE
        data_out <= 0; // Reset output to 0
    end else begin
        state <= next_state; // Update current state
        case (state)
            IDLE: begin
                if (data_in) begin
                    next_state <= PEAK; // Transition to PEAK state if data_in is 1
                end else begin
                    next_state <= IDLE; // Stay in IDLE state if data_in is 0
                end
                data_out <= 0; // Reset output in IDLE state
            end
            PEAK: begin
                if (!data_in) begin
                    next_state <= FALLING; // Transition to FALLING state if data_in becomes 0
                    data_out <= 1; // Set output to 1, indicating pulse detection
                end else begin
                    next_state <= PEAK; // Stay in PEAK state if data_in remains 1
                    data_out <= 0; // Reset output
                end
            end
            FALLING: begin
                next_state <= IDLE; // Transition back to IDLE state
                data_out <= 0; // Reset output
            end
        endcase
    end
end

endmodule