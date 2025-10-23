module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Define states for the pulse detection process
typedef enum logic [1:0] {
    IDLE = 2'b00,
    RISING = 2'b01,
    FALLING = 2'b10
} state_t;

state_t state;
state_t next_state;

// Output signal indicating the presence of pulses
logic data_out;

// Always block sensitive to the positive edge of clk and negative edge of rst_n
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE; // Reset state to IDLE
        data_out <= 0; // Reset output to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= RISING; // Transition to RISING state if data_in is 1
                end else begin
                    state <= IDLE; // Stay in IDLE if data_in is 0
                end
            end
            RISING: begin
                if (~data_in) begin
                    state <= FALLING; // Transition to FALLING state if data_in is 0
                end else begin
                    state <= RISING; // Stay in RISING if data_in is 1
                end
            end
            FALLING: begin
                state <= IDLE; // Reset to IDLE after detecting a pulse
            end
            default: state <= IDLE; // Default state is IDLE
        endcase
    end
end

// Combinational logic to generate output based on state
always_comb begin
    case (state)
        IDLE: data_out = 0;
        RISING: data_out = 0;
        FALLING: data_out = 1; // Set data_out to 1 when a pulse is detected
        default: data_out = 0;
    endcase
end

endmodule