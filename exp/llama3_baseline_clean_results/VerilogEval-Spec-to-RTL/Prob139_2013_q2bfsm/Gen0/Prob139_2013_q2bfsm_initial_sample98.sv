module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define the states
parameter STATE_A = 3'b000;
parameter STATE_B = 3'b001;
parameter STATE_C = 3'b010;
parameter STATE_D = 3'b011;
parameter STATE_E = 3'b100;
parameter STATE_F = 3'b101;
parameter STATE_G = 3'b110;

// Define the state register
reg [2:0] state;
reg [2:0] next_state;

// Define the sequence counter for x
reg [1:0] x_seq;

// Define the counter for y
reg [1:0] y_cnt;

always @(*) begin
    // Default values
    next_state = state;
    f = 0;
    g = 0;

    case(state)
        STATE_A: begin
            if (~resetn) begin
                next_state = STATE_A;
            end else begin
                next_state = STATE_B;
            end
        end

        STATE_B: begin
            f = 1;
            next_state = STATE_C;
        end

        STATE_C: begin
            if (x) begin
                x_seq = 2;
                next_state = STATE_C;
            end else if (x_seq == 2) begin
                x_seq = 1;
                next_state = STATE_C;
            end else if (x_seq == 1 && x == 0) begin
                x_seq = 3;
                next_state = STATE_C;
            end else if (x_seq == 3 && x == 1) begin
                next_state = STATE_D;
            end else begin
                x_seq = 0;
                next_state = STATE_C;
            end
        end

        STATE_D: begin
            g = 1;
            next_state = STATE_E;
        end

        STATE_E: begin
            g = 1;
            if (y) begin
                next_state = STATE_F;
            end else if (y_cnt == 2) begin
                next_state = STATE_G;
            end else begin
                y_cnt = y_cnt + 1;
                next_state = STATE_E;
            end
        end

        STATE_F: begin
            g = 1;
            next_state = STATE_F;
        end

        STATE_G: begin
            next_state = STATE_G;
        end
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        state <= STATE_A;
        x_seq <= 0;
        y_cnt <= 0;
    end else begin
        state <= next_state;
        if (state == STATE_C && x) begin
            x_seq <= 2;
        end else if (state == STATE_C && x_seq == 2) begin
            x_seq <= 1;
        end else if (state == STATE_C && x_seq == 1 && x == 0) begin
            x_seq <= 3;
        end else if (state == STATE_C && x_seq == 3 && x == 1) begin
            x_seq <= 0;
        end else if (state == STATE_C && x_seq == 0 && x == 0) begin
            x_seq <= 0;
        end

        if (state == STATE_E) begin
            if (y) begin
                y_cnt <= 0;
            end else if (y_cnt < 2) begin
                y_cnt <= y_cnt + 1;
            end
        end else begin
            y_cnt <= 0;
        end
    end
end
endmodule