module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the FSM
reg [1:0] state;
localparam IDLE = 2'b00;
localparam RISING = 2'b01;
localparam FALLING = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set state to IDLE and data_out to 0
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    // Rising edge detected, transition to RISING state
                    state <= RISING;
                    data_out <= 0;
                end else begin
                    // No rising edge, stay in IDLE state
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            RISING: begin
                if (data_in) begin
                    // Still high, stay in RISING state
                    state <= RISING;
                    data_out <= 0;
                end else begin
                    // Falling edge detected, transition to FALLING state
                    state <= FALLING;
                    data_out <= 0;
                end
            end
            FALLING: begin
                if (~data_in) begin
                    // Still low, set data_out to 1 indicating the end of a pulse
                    state <= IDLE;
                    data_out <= 1;
                end else begin
                    // Unexpected rising edge, reset to IDLE state
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            default: begin
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule