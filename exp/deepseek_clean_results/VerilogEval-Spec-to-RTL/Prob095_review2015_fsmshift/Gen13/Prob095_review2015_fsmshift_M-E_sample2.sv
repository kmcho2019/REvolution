module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] counter;
    reg state;

    localparam IDLE = 1'b0;
    localparam ACTIVE = 1'b1;

    always @(posedge clk) begin
        if (reset) begin
            state <= ACTIVE;
            counter <= 3'b000;
        end else begin
            case (state)
                ACTIVE: begin
                    if (counter == 3'b011) begin  // After 4 cycles (0-3)
                        state <= IDLE;
                    end
                    counter <= counter + 1;
                end
                IDLE: begin
                    // Stay in IDLE until next reset
                end
            endcase
        end
    end

    assign shift_ena = (state == ACTIVE);

endmodule