module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define the states for the finite state machine
localparam IDLE = 2'd0;
localparam RISE = 2'd1;
localparam FALL = 2'd2;
localparam PULSE_END = 2'd3;

reg [1:0] state;
reg [1:0] next_state;

// Initialize state and data_out
initial begin
    state = IDLE;
    data_out = 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: set state to IDLE and data_out to 0
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        // Pulse detection logic
        case (state)
            IDLE: begin
                if (data_in) begin
                    // Transition to RISE state when data_in rises
                    state <= RISE;
                    data_out <= 1'b0;
                end else begin
                    // Stay in IDLE state if data_in remains low
                    state <= IDLE;
                    data_out <= 1'b0;
                end
            end
            RISE: begin
                if (~data_in) begin
                    // Transition to FALL state when data_in falls
                    state <= FALL;
                    data_out <= 1'b0;
                end else begin
                    // Stay in RISE state if data_in remains high
                    state <= RISE;
                    data_out <= 1'b0;
                end
            end
            FALL: begin
                if (~data_in) begin
                    // Transition to PULSE_END state when data_in stays low
                    state <= PULSE_END;
                    data_out <= 1'b0;
                end else begin
                    // Transition back to RISE state if data_in rises again
                    state <= RISE;
                    data_out <= 1'b0;
                end
            end
            PULSE_END: begin
                // Set data_out to 1, indicating the end of a pulse
                data_out <= 1'b1;
                // Reset state to IDLE
                state <= IDLE;
            end
            default: begin
                state <= IDLE;
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule