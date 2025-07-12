module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    // Define the states of the FSM
    enum logic [1:0] {
        IDLE,
        SHIFT_ENABLE
    } state, next_state;

    // Define the counter to track the number of clock cycles
    logic [1:0] counter;

    // Sequential logic to update the state and counter
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SHIFT_ENABLE;
            counter <= 4;
        end else begin
            state <= next_state;
            if (state == SHIFT_ENABLE) begin
                if (counter > 1) begin
                    counter <= counter - 1;
                end else begin
                    counter <= 0;
                end
            end
        end
    end

    // Combinational logic to determine the next state
    always_comb begin
        case(state)
            IDLE: next_state = IDLE;
            SHIFT_ENABLE: begin
                if (counter == 1) begin
                    next_state = IDLE;
                end else begin
                    next_state = SHIFT_ENABLE;
                end
            end
        endcase
    end

    // Assert shift_ena when in the SHIFT_ENABLE state
    assign shift_ena = (state == SHIFT_ENABLE);

endmodule