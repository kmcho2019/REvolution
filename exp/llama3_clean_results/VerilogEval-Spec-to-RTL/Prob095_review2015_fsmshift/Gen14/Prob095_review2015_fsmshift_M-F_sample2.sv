module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {IDLE, SHIFTING} state;

    logic [1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SHIFTING;
            counter <= 3;
        end else begin
            case (state)
                IDLE: begin
                    // No action needed in IDLE state
                end
                SHIFTING: begin
                    if (counter > 0) begin
                        counter <= counter - 1;
                    end else begin
                        state <= IDLE;
                        counter <= 0;
                    end
                end
            endcase
        end
    end

    assign shift_ena = (state == SHIFTING) && (counter > 0);

endmodule