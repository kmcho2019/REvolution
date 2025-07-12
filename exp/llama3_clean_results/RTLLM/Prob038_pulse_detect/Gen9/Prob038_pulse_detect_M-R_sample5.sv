module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the FSM using binary encoding
reg [1:0] current_state;

// Initialize current_state to Idle
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        current_state <= 2'b00; // Idle state
    end else begin
        case (current_state)
            2'b00: // Idle state
                if (data_in == 1) begin
                    current_state <= 2'b01; // Transition to High state
                end else begin
                    current_state <= 2'b00; // Remain in Idle state
                end
            2'b01: // High state
                if (data_in == 0) begin
                    current_state <= 2'b10; // Transition to PulseEnd state
                end else begin
                    current_state <= 2'b01; // Remain in High state
                end
            2'b10: // PulseEnd state
                current_state <= 2'b00; // Transition back to Idle state
            default: // Default to Idle state
                current_state <= 2'b00;
        endcase
    end
end

// Combinational logic for output signal
always @(*) begin
    case (current_state)
        2'b00, 2'b01: data_out = 0;
        2'b10: data_out = 1;
        default: data_out = 0;
    endcase
end

endmodule