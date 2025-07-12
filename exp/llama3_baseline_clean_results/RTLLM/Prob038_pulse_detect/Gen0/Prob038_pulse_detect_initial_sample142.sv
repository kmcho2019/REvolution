module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Declare the states
parameter IDLE = 2'b00;
parameter RISING = 2'b01;
parameter HIGH = 2'b10;
parameter FALLING = 2'b11;

// Declare the state register
reg [1:0] state;

// Initialize the state register
initial state = IDLE;

// Always block for pulse detection and output generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: set state to IDLE and data_out to 0
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    // Transition to RISING state if data_in is 1
                    state <= RISING;
                    data_out <= 0;
                end else begin
                    // Stay in IDLE state if data_in is 0
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            RISING: begin
                if (data_in) begin
                    // Transition to HIGH state if data_in remains 1
                    state <= HIGH;
                    data_out <= 0;
                end else begin
                    // Transition back to IDLE state if data_in is 0
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            HIGH: begin
                if (data_in) begin
                    // Stay in HIGH state if data_in remains 1
                    state <= HIGH;
                    data_out <= 0;
                end else begin
                    // Transition to FALLING state if data_in is 0
                    state <= FALLING;
                    data_out <= 1;
                end
            end
            FALLING: begin
                // Transition back to IDLE state
                state <= IDLE;
                data_out <= 0;
            end
            default: begin
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule