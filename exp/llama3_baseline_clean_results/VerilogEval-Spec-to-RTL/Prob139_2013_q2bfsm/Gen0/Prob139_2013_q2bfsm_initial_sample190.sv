module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

reg [2:0] state; // current state
reg [2:0] nextState; // next state
reg f_reg; // output f
reg g_reg; // output g
reg x_prev; // previous value of x
reg x_prev_prev; // value of x two clock cycles ago
reg y_timer; // timer for y input

always @(*) begin
    case(state)
        3'b000: begin // State A
            f_reg = 0;
            g_reg = 0;
            if (~resetn) begin
                nextState = 3'b000; // stay in State A if reset is asserted
            end else begin
                nextState = 3'b001; // go to State B if reset is de-asserted
            end
        end
        3'b001: begin // State B
            f_reg = 1;
            g_reg = 0;
            nextState = 3'b010; // go to State C
        end
        3'b010: begin // State C
            f_reg = 0;
            g_reg = 0;
            if (x_prev_prev == 1 && x_prev == 0 && x == 1) begin
                nextState = 3'b011; // go to State D if x sequence is 1, 0, 1
            end else begin
                nextState = 3'b010; // stay in State C
            end
        end
        3'b011: begin // State D
            f_reg = 0;
            g_reg = 1;
            if (y_timer < 2) begin
                if (y) begin
                    nextState = 3'b100; // go to State E if y becomes 1
                end else begin
                    y_timer = y_timer + 1;
                    nextState = 3'b011; // stay in State D and increment y timer
                end
            end else begin
                nextState = 3'b101; // go to State F if y timer reaches 2
            end
        end
        3'b100: begin // State E
            f_reg = 0;
            g_reg = 1;
            nextState = 3'b100; // stay in State E
        end
        3'b101: begin // State F
            f_reg = 0;
            g_reg = 0;
            nextState = 3'b101; // stay in State F
        end
        default: begin
            f_reg = 0;
            g_reg = 0;
            nextState = 3'b000; // go to State A if invalid state
        end
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        state <= 3'b000; // reset state to State A
        x_prev <= 0;
        x_prev_prev <= 0;
        y_timer <= 0;
    end else begin
        state <= nextState;
        x_prev_prev <= x_prev;
        x_prev <= x;
        if (state == 3'b011) begin
            if (y) begin
                y_timer <= 0;
            end else if (y_timer < 2) begin
                y_timer <= y_timer + 1;
            end
        end else begin
            y_timer <= 0;
        end
    end
    f <= f_reg;
    g <= g_reg;
end

endmodule