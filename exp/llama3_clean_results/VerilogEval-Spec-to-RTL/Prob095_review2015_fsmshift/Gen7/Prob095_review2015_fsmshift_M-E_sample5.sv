module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {IDLE, SHIFT} state;
    logic [1:0] counter;

    always_ff @(posedge clk) begin
        case(state)
            IDLE: begin
                if (reset) begin
                    state <= SHIFT;
                    counter <= 0;
                    shift_ena <= 1'b1;
                end
            end
            SHIFT: begin
                counter <= counter + 1'b1;
                if (counter == 2'b11) begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                end
            end
        endcase
    end

endmodule