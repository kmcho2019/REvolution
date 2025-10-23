module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // Define states
    localparam IDLE = 1'b0;
    localparam ACTIVE = 1'b1;

    reg state;
    reg [1:0] counter;

    // State transition and counter logic
    always @(posedge clk) begin
        if (reset) begin
            state <= ACTIVE;
            counter <= 2'b00;
        end else begin
            case (state)
                ACTIVE: begin
                    if (counter == 2'b11) begin
                        state <= IDLE;
                    end
                    counter <= counter + 1;
                end
                IDLE: begin
                    // Stay in IDLE until reset
                    counter <= 2'b00;
                end
            endcase
        end
    end

    // Output logic - asserted during ACTIVE state (cycles 0-3)
    assign shift_ena = (state == ACTIVE);

endmodule