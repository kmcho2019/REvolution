module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

// Define states
enum logic [2:0] {
    STATE_A = 3'b001,
    STATE_B = 3'b010,
    STATE_C = 3'b011,
    STATE_D = 3'b100,
    STATE_E = 3'b101,
    STATE_F = 3'b110
} state, next_state;

// Output and internal signals
logic f_next, g_next;
logic [1:0] x_sequence;
logic [1:0] y_counter;

always_ff @(posedge clk) begin
    if (~resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
        x_sequence <= 0;
        y_counter <= 0;
    end else begin
        state <= next_state;
        f <= f_next;
        g <= g_next;
        x_sequence <= {x_sequence[0], x};
        if (state == STATE_D) begin
            if (y)
                y_counter <= 2'b11; // Mark y as seen
            else
                y_counter <= y_counter + 1;
        end else
            y_counter <= 0;
    end
end

always_comb begin
    next_state = state;
    f_next = 0;
    g_next = g;

    case (state)
        STATE_A: begin
            if (resetn) begin
                next_state = STATE_B;
            end
        end
        STATE_B: begin
            f_next = 1;
            next_state = STATE_C;
        end
        STATE_C: begin
            if (x_sequence == 2'b10) begin
                next_state = STATE_D;
            end else if (x_sequence == 2'b01) begin
                x_sequence = {1'b1, x}; // Start sequence check again
            end
        end
        STATE_D: begin
            g_next = 1;
            if (y_counter == 2'b10 || y_counter == 2'b11) begin
                next_state = STATE_E;
            end else if (y_counter == 2) begin
                next_state = STATE_F;
            end
        end
        STATE_E: begin
            g_next = 1;
        end
        STATE_F: begin
            g_next = 0;
        end
    endcase
end

endmodule