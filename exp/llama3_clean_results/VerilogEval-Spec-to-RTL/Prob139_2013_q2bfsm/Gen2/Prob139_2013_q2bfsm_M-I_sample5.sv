module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Define the states
enum logic [1:0] {
    STATE_A = 2'b00,
    STATE_B = 2'b01,
    STATE_C = 2'b10,
    STATE_D = 2'b11
} state, next_state;

// Define the signals
reg f_reg;
reg g_reg;
reg [2:0] x_seq;
reg [1:0] y_timer;

// Initialize the signals
initial begin
    state = STATE_A;
    x_seq = 3'b000;
    y_timer = 2'b00;
    f_reg = 1'b0;
    g_reg = 1'b0;
end

// Main logic
always @ (posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_seq <= 3'b000;
        y_timer <= 2'b00;
        f_reg <= 1'b0;
        g_reg <= 1'b0;
    end else begin
        case (state)
            STATE_A: begin
                if (resetn) begin
                    state <= STATE_B;
                    f_reg <= 1'b1;
                end
            end
            STATE_B: begin
                state <= STATE_C;
                f_reg <= 1'b0;
            end
            STATE_C: begin
                if (x) begin
                    x_seq <= {x_seq[1:0], 1'b1};
                end else begin
                    x_seq <= {x_seq[1:0], 1'b0};
                end
                if (x_seq == 3'b101) begin
                    state <= STATE_D;
                    g_reg <= 1'b1;
                end
            end
            STATE_D: begin
                if (!g_reg) begin
                    y_timer <= y_timer + 1'b1;
                    if (y) begin
                        g_reg <= 1'b1;
                    end else if (y_timer == 2'b10) begin
                        g_reg <= 1'b0;
                    end
                end
            end
        endcase
    end
end

// Output logic
assign f = f_reg;
assign g = g_reg;

endmodule