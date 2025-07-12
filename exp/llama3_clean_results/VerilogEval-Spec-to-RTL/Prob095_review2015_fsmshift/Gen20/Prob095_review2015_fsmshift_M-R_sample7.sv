module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    // State definition
    enum logic [1:0] {IDLE_STATE, RESET_STATE} state;

    // Counter to track cycles during reset
    logic [1:0] counter;

    // Sequential logic for state machine
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= RESET_STATE;
            counter <= 2'b00;
        end else begin
            case (state)
                RESET_STATE: begin
                    counter <= counter + 1'b1;
                    if (counter == 4'd3) begin
                        state <= IDLE_STATE;
                    end
                end
                IDLE_STATE: begin
                    // Stay in IDLE_STATE until next reset
                end
            endcase
        end
    end

    // Combinational logic for shift_ena
    assign shift_ena = (state == RESET_STATE);

endmodule