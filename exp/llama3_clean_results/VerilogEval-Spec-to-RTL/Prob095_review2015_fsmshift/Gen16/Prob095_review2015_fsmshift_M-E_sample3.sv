module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    // Define states
    enum logic [1:0] {
        IDLE = 2'b00,
        RESET = 2'b01,
        SHIFT_ENABLE = 2'b10
    } state, next_state;

    // Counter to track cycles during reset
    logic [1:0] counter;

    // Sequential logic for state transitions
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= RESET;
            counter <= 2'b11; // Set counter to 3 to ensure 4 cycles
        end else begin
            state <= next_state;
            if (state == RESET) begin
                if (counter > 0) begin
                    counter <= counter - 1;
                end else begin
                    counter <= 2'b00;
                end
            end else begin
                counter <= 2'b00;
            end
        end
    end

    // Combinational logic for next state and output
    always_comb begin
        next_state = state;
        shift_ena = 1'b0; // Default shift_ena to 0

        case (state)
            IDLE: begin
                if (reset) begin
                    next_state = RESET;
                end
            end
            RESET: begin
                shift_ena = 1'b1; // Assert shift_ena during reset state
                if (counter == 0) begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule