module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {IDLE, SHIFTING} state;

    logic [1:0] counter;

    always_ff @(posedge clk) begin
        case (state)
            IDLE: begin
                if (reset) begin
                    state <= SHIFTING;
                    counter <= 3;
                end
            end
            SHIFTING: begin
                if (counter > 0) begin
                    counter <= counter - 1;
                end else begin
                    state <= IDLE;
                end
            end
        endcase
        shift_ena <= (state == SHIFTING);
    end

endmodule