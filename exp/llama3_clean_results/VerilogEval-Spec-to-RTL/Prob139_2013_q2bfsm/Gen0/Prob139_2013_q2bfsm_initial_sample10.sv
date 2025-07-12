module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State enumeration
enum logic [1:0] {
    STATE_A,
    STATE_B,
    STATE_C,
    STATE_D
} state, next_state;

// Counter for x sequence
reg [1:0] x_counter;

// Timer for y input
reg [1:0] y_timer;

always @(*) begin
    case (state)
        STATE_A: begin
            if (~resetn) begin
                next_state = STATE_A;
                f = 0;
                g = 0;
            end else begin
                next_state = STATE_B;
                f = 1;
                g = 0;
            end
        end
        STATE_B: begin
            next_state = STATE_C;
            f = 0;
            g = 0;
            x_counter = 0;
        end
        STATE_C: begin
            if (x_counter == 0 && x) begin
                x_counter = 1;
            end else if (x_counter == 1 && ~x) begin
                x_counter = 2;
            end else if (x_counter == 2 && x) begin
                x_counter = 0;
                next_state = STATE_D;
                g = 1;
            end else begin
                next_state = STATE_C;
                g = 0;
            end
            f = 0;
        end
        STATE_D: begin
            next_state = STATE_D;
            f = 0;
            if (y) begin
                y_timer = 0;
                g = 1;
            end else if (y_timer < 2) begin
                y_timer = y_timer + 1;
                if (y_timer == 2) begin
                    g = 0;
                end else begin
                    g = 1;
                end
            end else begin
                g = 0;
            end
        end
        default: begin
            next_state = STATE_A;
            f = 0;
            g = 0;
        end
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        state = STATE_A;
    end else begin
        state = next_state;
    end
end

endmodule