module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] { IDLE, SHIFTING } state;

    logic [1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SHIFTING;
            counter <= 3;
        end else begin
            case (state)
                SHIFTING: begin
                    counter <= counter - 1;
                    if (counter == 0) begin
                        state <= IDLE;
                    end
                end
                IDLE: begin
                    // Do nothing
                end
            endcase
        end
    end

    assign shift_ena = (state == SHIFTING);

endmodule