module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter;
    enum logic [1:0] {IDLE, SHIFT_ENA} state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 3;
        end else begin
            state <= next_state;
            if (state == SHIFT_ENA) begin
                if (counter > 0) begin
                    counter <= counter - 1'b1;
                end else begin
                    state <= IDLE;
                end
            end
        end
    end

    always_comb begin
        case (state)
            IDLE: next_state = (reset) ? SHIFT_ENA : IDLE;
            SHIFT_ENA: next_state = (counter > 0) ? SHIFT_ENA : IDLE;
        endcase
    end

    assign shift_ena = (state == SHIFT_ENA);

endmodule