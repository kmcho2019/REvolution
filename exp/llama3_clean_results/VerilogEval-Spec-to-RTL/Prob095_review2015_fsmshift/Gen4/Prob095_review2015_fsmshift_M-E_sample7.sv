module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {IDLE, SHIFT} state, next_state;
    logic [1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SHIFT;
            counter <= 2'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT) begin
                counter <= counter + 1'b1;
            end else begin
                counter <= 2'd0;
            end
        end
    end

    always_comb begin
        case (state)
            IDLE: begin
                next_state = reset ? SHIFT : IDLE;
                shift_ena = 1'b0;
            end
            SHIFT: begin
                next_state = (counter == 2'd3) ? IDLE : SHIFT;
                shift_ena = 1'b1;
            end
        endcase
    end

endmodule