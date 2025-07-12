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

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SHIFT;
            counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (reset) begin
                        state <= SHIFT;
                        counter <= 0;
                    end else begin
                        state <= IDLE;
                    end
                end
                SHIFT: begin
                    counter <= counter + 1;
                    if (counter == 4) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    always_comb begin
        case (state)
            IDLE: shift_ena = 0;
            SHIFT: shift_ena = 1;
        endcase
    end

endmodule