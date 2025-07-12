module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

enum logic [1:0] {
    STATE_A,
    STATE_B,
    STATE_C,
    STATE_D
} state, next_state;

reg [1:0] x_seq;
reg [1:0] y_count;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_seq <= 2'b00;
        y_count <= 2'b00;
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        case (state)
            STATE_A: begin
                f <= 1'b1;
                state <= STATE_B;
            end
            STATE_B: begin
                x_seq <= {x_seq[0], x};
                if (x_seq == 2'b11) begin
                    state <= STATE_C;
                end else if (x_seq == 2'b10) begin
                    state <= STATE_B;
                end else if (x_seq == 2'b01) begin
                    state <= STATE_B;
                end else begin
                    state <= STATE_B;
                end
            end
            STATE_C: begin
                x_seq <= 2'b00;
                y_count <= y_count + 1'b1;
                if (y) begin
                    g <= 1'b1;
                    state <= STATE_D;
                end else if (y_count == 2'b10) begin
                    g <= 1'b0;
                    state <= STATE_D;
                end
            end
            STATE_D: begin
                // Stay in this state forever
            end
        endcase
    end
end

endmodule