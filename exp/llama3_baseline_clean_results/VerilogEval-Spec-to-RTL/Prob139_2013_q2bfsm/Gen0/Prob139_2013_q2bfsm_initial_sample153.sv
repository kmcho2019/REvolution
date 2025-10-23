module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

reg [2:0] state, next_state;
reg [1:0] x_count, next_x_count;
reg [1:0] y_count, next_y_count;
reg f_reg, next_f;
reg g_reg, next_g;

// State encoding
parameter STATE_A = 3'b000;
parameter STATE_B = 3'b001;
parameter STATE_C = 3'b010;
parameter STATE_D = 3'b011;
parameter STATE_E = 3'b100;
parameter STATE_F = 3'b101;

// Initial state and outputs
initial begin
    state = STATE_A;
    f_reg = 0;
    g_reg = 0;
    x_count = 0;
    y_count = 0;
end

// Next state logic
always @(*) begin
    next_state = state;
    next_f = f_reg;
    next_g = g_reg;
    next_x_count = x_count;
    next_y_count = y_count;

    case (state)
        STATE_A:
            if (~resetn) begin
                next_state = STATE_A;
            end else begin
                next_state = STATE_B;
            end

        STATE_B:
            next_state = STATE_C;
            next_f = 0;

        STATE_C:
            if (x_count == 0) begin
                if (x) begin
                    next_x_count = x_count + 1;
                end
            end else if (x_count == 1) begin
                if (~x) begin
                    next_x_count = x_count + 1;
                end else begin
                    next_x_count = 0;
                end
            end else if (x_count == 2) begin
                if (x) begin
                    next_state = STATE_D;
                    next_g = 1;
                    next_x_count = 0;
                end else begin
                    next_x_count = 0;
                end
            end

        STATE_D:
            next_state = STATE_E;

        STATE_E:
            if (y) begin
                next_state = STATE_E;
            end else if (y_count < 2) begin
                next_y_count = y_count + 1;
            end else begin
                next_state = STATE_F;
                next_g = 0;
            end

        STATE_F:
            next_state = STATE_F;

        default:
            next_state = STATE_A;
    endcase

    // Reset logic
    if (~resetn) begin
        next_state = STATE_A;
        next_f = 0;
        next_g = 0;
        next_x_count = 0;
        next_y_count = 0;
    end
end

// Sequential logic
always @(posedge clk) begin
    state <= next_state;
    f_reg <= next_f;
    g_reg <= next_g;
    x_count <= next_x_count;
    y_count <= next_y_count;

    if (state == STATE_B) begin
        f_reg <= 1;
    end

    if (state == STATE_E && y) begin
        y_count <= 0;
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule