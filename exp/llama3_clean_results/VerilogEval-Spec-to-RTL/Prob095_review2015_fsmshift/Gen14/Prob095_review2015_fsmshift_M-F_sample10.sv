module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {IDLE, SHIFTING} state = IDLE;
    logic [1:0] counter = 0;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SHIFTING;
            counter <= 1;
            shift_ena <= 1'b1;
        end
        else begin
            case (state)
                IDLE: begin
                    shift_ena <= 1'b0;
                end
                SHIFTING: begin
                    if (counter < 4) begin
                        counter <= counter + 1;
                    end
                    else begin
                        state <= IDLE;
                    end
                    shift_ena <= (state == SHIFTING && counter >= 1 && counter <= 4) ? 1'b1 : 1'b0;
                end
                default: begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                end
            endcase
        end
    end

endmodule