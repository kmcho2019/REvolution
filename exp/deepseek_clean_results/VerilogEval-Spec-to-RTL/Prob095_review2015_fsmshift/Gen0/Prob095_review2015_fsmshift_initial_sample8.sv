module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;
    reg state;

    // States
    localparam IDLE = 1'b0;
    localparam COUNTING = 1'b1;

    always @(posedge clk) begin
        if (reset) begin
            state <= COUNTING;
            counter <= 2'b00;
        end else begin
            case (state)
                COUNTING: begin
                    if (counter == 2'b11) begin
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

    assign shift_ena = (state == COUNTING);

endmodule