module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    // Define states
    enum logic [1:0] {IDLE_STATE, RESET_STATE} state, next_state;

    // Counter for counting cycles during reset
    logic [1:0] counter;

    // Always block for sequential logic
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= RESET_STATE;
            counter <= 4 - 1; // Initialize counter for 4 cycles
        end else begin
            state <= next_state;
            if (state == RESET_STATE) begin
                if (counter > 0) begin
                    counter <= counter - 1;
                end else begin
                    counter <= 0; // Ensure counter doesn't go below 0
                end
            end
        end
    end

    // Combinational logic for next state and outputs
    always_comb begin
        case (state)
            RESET_STATE: begin
                if (counter == 0) begin
                    next_state = IDLE_STATE;
                end else begin
                    next_state = RESET_STATE;
                end
                shift_ena = 1'b1; // Enable shift_ena during reset state
            end
            IDLE_STATE: begin
                next_state = IDLE_STATE; // Stay in idle state
                shift_ena = 1'b0; // Disable shift_ena in idle state
            end
            default: begin
                next_state = IDLE_STATE;
                shift_ena = 1'b0;
            end
        endcase
    end

endmodule