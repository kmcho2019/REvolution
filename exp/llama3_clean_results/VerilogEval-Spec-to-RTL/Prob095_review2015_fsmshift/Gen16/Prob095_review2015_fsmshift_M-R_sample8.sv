module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    // Define the states of the FSM
    enum logic [1:0] {
        IDLE,
        SHIFT_ENABLE
    } state;

    // Define the counter to track the number of clock cycles
    logic [1:0] counter;

    // Sequential logic to update the state and counter
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SHIFT_ENABLE;
            counter <= 4;
        end else if (state == SHIFT_ENABLE) begin
            if (counter > 1) begin
                counter <= counter - 1;
            end else begin
                state <= IDLE;
                counter <= 0;
            end
        end
    end

    // Assert shift_ena when in the SHIFT_ENABLE state
    assign shift_ena = (state == SHIFT_ENABLE) && (counter > 0);

endmodule