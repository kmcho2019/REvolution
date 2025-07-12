module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {
        IDLE_STATE = 2'b00,
        RESET_STATE = 2'b01
    } state, next_state;

    logic [1:0] counter, next_counter;

    // Initialize state to IDLE_STATE
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= RESET_STATE;
            counter <= 4;
        end else begin
            state <= next_state;
            counter <= next_counter;
        end
    end

    always_comb begin
        case(state)
            IDLE_STATE: begin
                if (reset) begin
                    next_state = RESET_STATE;
                    next_counter = 4;
                end else begin
                    next_state = IDLE_STATE;
                    next_counter = 0;
                end
            end
            RESET_STATE: begin
                if (counter > 1) begin // Decrement counter until it reaches 1
                    next_state = RESET_STATE;
                    next_counter = counter - 1;
                end else begin
                    next_state = IDLE_STATE;
                    next_counter = 0;
                end
            end
        endcase
    end

    // Assert shift_ena when counter is greater than 0
    assign shift_ena = (counter > 0);

endmodule