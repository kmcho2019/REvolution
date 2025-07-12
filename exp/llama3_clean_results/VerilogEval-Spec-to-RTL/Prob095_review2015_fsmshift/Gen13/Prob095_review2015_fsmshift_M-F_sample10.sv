module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {
        IDLE_STATE = 2'b00,
        RESET_STATE = 2'b01
    } state, next_state;

    logic [1:0] counter;

    // Initialize state and counter
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= RESET_STATE;
            counter <= 4;
        end else begin
            if (state == RESET_STATE) begin
                if (counter > 0) begin
                    counter <= counter - 1;
                end else begin
                    state <= IDLE_STATE;
                end
            end else begin
                state <= IDLE_STATE;
            end
        end
    end

    // Assert shift_ena when in RESET_STATE
    assign shift_ena = (state == RESET_STATE && counter > 0) || (counter > 0);

endmodule