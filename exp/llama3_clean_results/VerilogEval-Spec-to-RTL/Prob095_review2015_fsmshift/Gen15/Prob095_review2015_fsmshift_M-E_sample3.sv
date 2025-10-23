module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {
        IDLE = 2'b00,
        SHIFT = 2'b01
    } state, next_state;

    logic [1:0] counter;

    // Initialize state and counter
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SHIFT;
            counter <= 4;
        end else begin
            case (state)
                IDLE: begin
                    state <= IDLE;
                end
                SHIFT: begin
                    if (counter > 1) begin
                        counter <= counter - 1;
                    end else begin
                        state <= IDLE;
                        counter <= 0;
                    end
                end
            endcase
        end
    end

    // Assert shift_ena when in SHIFT state
    assign shift_ena = (state == SHIFT) && (counter > 0);

endmodule