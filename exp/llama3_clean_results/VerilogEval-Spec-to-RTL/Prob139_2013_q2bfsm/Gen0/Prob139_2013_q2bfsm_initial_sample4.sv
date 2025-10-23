module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

// Enum for states
enum logic [2:0] {S_A, S_F, S_X1, S_X2, S_X3, S_G, S_Y1, S_Y2} state, next_state;

// Output registers
logic f_reg, g_reg;

always_ff @(posedge clk) begin
    if (~resetn) begin
        state <= S_A;
        f_reg <= 0;
        g_reg <= 0;
    end else begin
        state <= next_state;
        f_reg <= (state == S_F) ? 1 : 0;
        g_reg <= (state == S_G || state == S_Y1 || state == S_Y2) ? 1 : 0;
    end
end

always_comb begin
    next_state = state;
    case (state)
        S_A: begin
            if (resetn) begin
                next_state = S_F;
            end
        end
        S_F: begin
            next_state = S_X1;
        end
        S_X1: begin
            if (x) begin
                next_state = S_X2;
            end else begin
                next_state = S_X1;
            end
        end
        S_X2: begin
            if (~x) begin
                next_state = S_X3;
            end else begin
                next_state = S_X1;
            end
        end
        S_X3: begin
            if (x) begin
                next_state = S_G;
            end else begin
                next_state = S_X1;
            end
        end
        S_G: begin
            next_state = S_Y1;
        end
        S_Y1: begin
            if (y) begin
                next_state = S_G;
            end else begin
                next_state = S_Y2;
            end
        end
        S_Y2: begin
            if (y) begin
                next_state = S_G;
            end else begin
                next_state = S_G; // actually, g_reg should be set to 0, so use a separate logic for g_reg
            end
        end
        default: next_state = S_A;
    endcase
end

assign f = f_reg;
assign g = (state == S_G || state == S_Y1) ? 1 : (state == S_Y2 && !y) ? 0 : g_reg;

endmodule