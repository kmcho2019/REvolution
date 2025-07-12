module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define the states of the FSM
localparam IDLE = 2'b00;
localparam RISING_EDGE = 2'b01;
localparam PULSE_HIGH = 2'b10;
localparam PULSE_LOW = 2'b11;

reg [1:0] state; // Register to keep track of the current state

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE; // Initialize the state to IDLE
        data_out <= 1'b0; // Initialize the output to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // Check for rising edge
                    state <= RISING_EDGE;
                    data_out <= 1'b0;
                end else begin
                    state <= IDLE;
                    data_out <= 1'b0;
                end
            end
            RISING_EDGE: begin
                if (data_in) begin // Check for pulse high
                    state <= PULSE_HIGH;
                    data_out <= 1'b0;
                end else begin
                    state <= IDLE;
                    data_out <= 1'b0;
                end
            end
            PULSE_HIGH: begin
                if (~data_in) begin // Check for pulse low
                    state <= PULSE_LOW;
                    data_out <= 1'b0;
                end else begin
                    state <= PULSE_HIGH;
                    data_out <= 1'b0;
                end
            end
            PULSE_LOW: begin
                if (~data_in) begin // Pulse detected, set output to 1
                    state <= IDLE;
                    data_out <= 1'b1;
                end else begin
                    state <= PULSE_HIGH;
                    data_out <= 1'b0;
                end
            end
            default: begin
                state <= IDLE;
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule