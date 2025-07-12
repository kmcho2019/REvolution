module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the FSM
enum logic [1:0] {idle, rising_edge_detected, falling_edge_detected} state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= idle;
        data_out <= 0;
    end else begin
        state <= next_state;
        case (state)
            idle: begin
                if (data_in) begin
                    next_state <= rising_edge_detected;
                    data_out <= 0;
                end else begin
                    next_state <= idle;
                    data_out <= 0;
                end
            end
            rising_edge_detected: begin
                if (!data_in) begin
                    next_state <= falling_edge_detected;
                    data_out <= 1; // Set data_out to 1 at the falling edge
                end else begin
                    next_state <= rising_edge_detected;
                    data_out <= 0;
                end
            end
            falling_edge_detected: begin
                next_state <= idle;
                data_out <= 0; // Reset data_out after the pulse
            end
            default: begin
                next_state <= idle;
                data_out <= 0;
            end
        endcase
    end
end

endmodule