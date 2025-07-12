module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {
        IDLE,
        SHIFTING
    } state;

    logic [1:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SHIFTING;
            count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    // do nothing
                end
                SHIFTING: begin
                    count <= count + 1;
                    if (count == 3) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    assign shift_ena = (state == SHIFTING);

endmodule