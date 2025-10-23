module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

parameter STATE_A = 4'd0;
parameter STATE_B = 4'd1;
parameter STATE_C = 4'd2;
parameter STATE_D = 4'd3;
parameter STATE_E = 4'd4;
parameter STATE_F = 4'd5;

reg [3:0] current_state;
reg [3:0] next_state;

reg [1:0] x_counter;
reg [1:0] y_counter;

always @(posedge clk) begin
    if (~resetn) begin
        current_state <= STATE_A;
        f <= 1'b0;
        g <= 1'b0;
        x_counter <= 2'd0;
        y_counter <= 2'd0;
    end else begin
        current_state <= next_state;
        case (current_state)
            STATE_A: begin
                if (~resetn) begin
                    next_state <= STATE_A;
                end else begin
                    next_state <= STATE_B;
                end
                f <= 1'b0;
                g <= 1'b0;
                x_counter <= 2'd0;
                y_counter <= 2'd0;
            end
            STATE_B: begin
                next_state <= STATE_C;
                f <= 1'b1;
                g <= 1'b0;
                x_counter <= 2'd0;
                y_counter <= 2'd0;
            end
            STATE_C: begin
                if (x) begin
                    x_counter <= x_counter + 1;
                end else begin
                    x_counter <= 2'd0;
                end
                if (x_counter == 2'd3) begin
                    next_state <= STATE_D;
                end else begin
                    next_state <= STATE_C;
                end
                f <= 1'b0;
                g <= 1'b0;
                y_counter <= 2'd0;
            end
            STATE_D: begin
                next_state <= STATE_E;
                f <= 1'b0;
                g <= 1'b1;
                y_counter <= y_counter + 1;
            end
            STATE_E: begin
                if (y) begin
                    next_state <= STATE_E;
                    y_counter <= 2'd0;
                end else if (y_counter < 2'd2) begin
                    next_state <= STATE_E;
                    y_counter <= y_counter + 1;
                end else begin
                    next_state <= STATE_F;
                end
                f <= 1'b0;
                if (next_state == STATE_E) begin
                    g <= 1'b1;
                end else begin
                    g <= 1'b0;
                end
            end
            STATE_F: begin
                next_state <= STATE_F;
                f <= 1'b0;
                g <= 1'b0;
            end
        endcase
    end
end

endmodule