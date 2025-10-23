module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the finite state machine
localparam IDLE = 2'b00;
localparam RISING = 2'b01;
localparam HIGH = 2'b10;
localparam FALLING = 2'b11;

// Declare state register
reg [1:0] state;
reg [1:0] next_state;

// Initialize output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: set state to IDLE and data_out to 0
        state <= IDLE;
        data_out <= 0;
    end else begin
        // Update state and output based on current state and input
        case (state)
            IDLE: begin
                if (data_in) begin
                    // Transition to RISING state when data_in is 1
                    state <= RISING;
                    data_out <= 0;
                end else begin
                    // Stay in IDLE state when data_in is 0
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            RISING: begin
                if (data_in) begin
                    // Transition to HIGH state when data_in is 1
                    state <= HIGH;
                    data_out <= 0;
                end else begin
                    // Transition back to IDLE state when data_in is 0
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            HIGH: begin
                if (data_in) begin
                    // Stay in HIGH state when data_in is 1
                    state <= HIGH;
                    data_out <= 0;
                end else begin
                    // Transition to FALLING state when data_in is 0
                    state <= FALLING;
                    data_out <= 1;
                end
            end
            FALLING: begin
                // Transition back to IDLE state and reset data_out
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