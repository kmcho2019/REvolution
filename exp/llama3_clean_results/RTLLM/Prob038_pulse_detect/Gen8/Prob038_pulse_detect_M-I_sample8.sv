module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the FSM using one-hot encoding
reg [2:0] current_state;
reg [2:0] next_state;

// Initialize current_state to Idle
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        current_state <= 3'b001; // Idle state
        data_out <= 0;
    end else begin
        current_state <= next_state;
        case (current_state)
            3'b001: begin // Idle state
                if (data_in == 1) begin
                    next_state <= 3'b010; // Transition to High state
                    data_out <= 0;
                end else begin
                    next_state <= 3'b001; // Remain in Idle state
                    data_out <= 0;
                end
            end
            3'b010: begin // High state
                if (data_in == 0) begin
                    next_state <= 3'b100; // Transition to PulseEnd state
                    data_out <= 1;
                end else begin
                    next_state <= 3'b010; // Remain in High state
                    data_out <= 0;
                end
            end
            3'b100: begin // PulseEnd state
                next_state <= 3'b001; // Transition back to Idle state
                data_out <= 0;
            end
            default: begin
                next_state <= 3'b001; // Default to Idle state
                data_out <= 0;
            end
        endcase
    end
end

endmodule