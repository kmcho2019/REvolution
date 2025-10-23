module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states
localparam IDLE = 2'b00;
localparam RISE = 2'b01;
localparam HIGH = 2'b10;
localparam FALL = 2'b11;

reg [1:0] state;

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set state to IDLE and data_out to 0
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    // Transition to RISE state when data_in is 1
                    state <= RISE;
                end else begin
                    // Stay in IDLE state if data_in is 0
                    state <= IDLE;
                end
                data_out <= 0;
            end
            RISE: begin
                if (data_in) begin
                    // Transition to HIGH state when data_in is 1
                    state <= HIGH;
                end else begin
                    // If data_in is 0, go back to IDLE state
                    state <= IDLE;
                end
                data_out <= 0;
            end
            HIGH: begin
                if (~data_in) begin
                    // Transition to FALL state when data_in is 0
                    state <= FALL;
                end else begin
                    // Stay in HIGH state if data_in is 1
                    state <= HIGH;
                end
                data_out <= 0;
            end
            FALL: begin
                if (~data_in) begin
                    // Set data_out to 1 when data_in is 0, indicating end of pulse
                    data_out <= 1;
                    // Transition back to IDLE state
                    state <= IDLE;
                end else begin
                    // If data_in is 1, go back to HIGH state
                    state <= HIGH;
                end
            end
            default: begin
                // Default case: Set state to IDLE and data_out to 0
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule