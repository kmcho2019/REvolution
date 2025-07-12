module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states
reg [1:0] state;
localparam IDLE = 2'b00;
localparam PULSE_1 = 2'b01;
localparam PULSE_0 = 2'b10;
localparam END_PULSE = 2'b11;

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set state to IDLE and data_out to 0
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                // Wait for start of pulse (data_in = 1)
                if (data_in == 1) begin
                    state <= PULSE_1;
                    data_out <= 0;
                end else begin
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            PULSE_1: begin
                // Wait for end of pulse (data_in = 0)
                if (data_in == 0) begin
                    state <= PULSE_0;
                    data_out <= 0;
                end else begin
                    state <= PULSE_1;
                    data_out <= 0;
                end
            end
            PULSE_0: begin
                // Pulse detected, set data_out to 1 and go to END_PULSE state
                state <= END_PULSE;
                data_out <= 1;
            end
            END_PULSE: begin
                // Go back to IDLE state and reset data_out to 0
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