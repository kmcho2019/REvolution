module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to store the current state

// Define the states
localparam IDLE = 2'b00;
localparam PULSE_RISING = 2'b01;
localparam PULSE_FALLING = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: set state to IDLE and data_out to 0
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    // If data_in is 1, transition to PULSE_RISING state
                    state <= PULSE_RISING;
                end else begin
                    // If data_in is 0, stay in IDLE state
                    state <= IDLE;
                end
                data_out <= 0; // No pulse detected, set data_out to 0
            end
            PULSE_RISING: begin
                if (~data_in) begin
                    // If data_in is 0, transition to PULSE_FALLING state
                    state <= PULSE_FALLING;
                end else begin
                    // If data_in is 1, stay in PULSE_RISING state
                    state <= PULSE_RISING;
                end
                data_out <= 0; // No pulse detected, set data_out to 0
            end
            PULSE_FALLING: begin
                if (data_in) begin
                    // If data_in is 1, it indicates the end of a pulse, set data_out to 1
                    data_out <= 1;
                end else begin
                    // If data_in is 0, it indicates the end of a pulse, transition to IDLE state and set data_out to 0
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            default: begin
                state <= IDLE; // Default state is IDLE
                data_out <= 0; // No pulse detected, set data_out to 0
            end
        endcase
    end
end

endmodule