module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

reg [1:0] x_seq;
reg [1:0] y_timer;
reg state_A, state_B, state_C, state_D, state_E;

always @(posedge clk) begin
    if (!resetn) begin
        state_A <= 1;
        state_B <= 0;
        state_C <= 0;
        state_D <= 0;
        state_E <= 0;
        f <= 0;
        g <= 0;
        x_seq <= 0;
        y_timer <= 0;
    end else if (state_A) begin
        state_A <= 0;
        state_B <= 1;
        f <= 1;
    end else if (state_B) begin
        state_B <= 0;
        state_C <= 1;
        f <= 0;
        x_seq <= x;
    end else if (state_C) begin
        x_seq <= {x_seq[0], x};
        if (x_seq == 2'b101) begin
            state_C <= 0;
            state_D <= 1;
            g <= 1;
            y_timer <= 1;
        end
    end else if (state_D) begin
        y_timer <= y_timer + 1;
        if (y) begin
            state_D <= 0;
            state_E <= 1;
        end else if (y_timer == 2) begin
            state_D <= 0;
            state_E <= 1;
            g <= 0;
        end
    end
end

endmodule