module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Current state
reg [1:0] next_state; // Next state

// Combinational logic to determine next state and output
always @(*) begin
    case (state)
        2'b00: begin // IDLE
            if (data_in) begin
                next_state = 2'b01; // Transition to HIGH state
            end else begin
                next_state = 2'b00; // Stay in IDLE
            end
        end
        2'b01: begin // HIGH
            if (data_in) begin
                next_state = 2'b01; // Stay in HIGH
            end else begin
                next_state = 2'b10; // Transition to FALLING
            end
        end
        2'b10: begin // FALLING
            next_state = 2'b00; // Transition back to IDLE
        end
        default: begin
            next_state = 2'b00; // Default to IDLE
        end
    endcase
end

// Sequential logic to update state and generate output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00; // Reset state to IDLE
        data_out <= 0; // Reset output
    end else begin
        state <= next_state; // Update state
        case (state)
            2'b10: begin // FALLING
                data_out <= 1; // Output is high when transitioning to FALLING
            end
            default: begin
                data_out <= 0; // Output is low in other states
            end
        endcase
    end
end

endmodule