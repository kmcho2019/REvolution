module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
reg prev_x;
reg y_wait_count;

always @(posedge clk) begin
    if (!resetn) begin
        state <= 2'b00; // STATE_A
        f <= 1'b0;
        g <= 1'b0;
        prev_x <= 1'b0;
        y_wait_count <= 2'b00;
    end else begin
        case (state)
            2'b00: begin // STATE_A
                if (prev_x == 1'b1) begin
                    state <= 2'b10; // STATE_SEQ
                end
                f <= 1'b1;
                g <= 1'b0;
            end
            2'b01: begin // STATE_SEQ
                if (x == 1'b1 && prev_x == 1'b0 && ~resetn) begin
                    state <= 2'b11; // STATE_WAIT_Y
                    g <= 1'b1;
                end
                f <= 1'b0;
            end
            2'b10: begin // STATE_SEQ
                f <= 1'b0;
                g <= 1'b0;
            end
            2'b11: begin // STATE_WAIT_Y
                if (y) begin
                    state <= 2'b11; // Stay in STATE_WAIT_Y
                    g <= 1'b1;
                end else if (y_wait_count == 2'b11) begin
                    state <= 2'b00; // Go back to STATE_A
                    g <= 1'b0;
                end else begin
                    y_wait_count <= y_wait_count + 1'b1;
                end
            end
        endcase
        prev_x <= x;
        if (state != 2'b11) begin
            y_wait_count <= 2'b00;
        end
    end
end

endmodule