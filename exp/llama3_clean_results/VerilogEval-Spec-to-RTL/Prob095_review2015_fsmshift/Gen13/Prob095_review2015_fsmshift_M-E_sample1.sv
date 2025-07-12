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
                    counter <= 4;
                end
            end
            SHIFTING: begin
                if (counter > 1) begin
                    counter <= counter - 1;
                end else begin
                    state <= IDLE;
                end
            end
        endcase
    end

    assign shift_ena = (state == SHIFTING)? 1'b1 : 1'b0;

endmodule