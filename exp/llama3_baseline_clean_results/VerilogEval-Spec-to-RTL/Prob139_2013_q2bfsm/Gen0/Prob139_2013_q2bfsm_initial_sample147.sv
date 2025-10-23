module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

// Define states
parameter STATE_A = 3'b000;
parameter STATE_B = 3'b001;
parameter STATE_C = 3'b010;
parameter STATE_D = 3'b011;
parameter STATE_E = 3'b100;
parameter STATE_F = 3'b101;
parameter STATE_G = 3'b110;

reg [2:0] current_state, next_state;
reg [1:0] x_sequence;
reg [1:0] y_timer;
reg f_reg, g_reg;

// State machine
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= STATE_A;
        f_reg <= 0;
        g_reg <= 0;
        x_sequence <= 0;
        y_timer <= 0;
    end else begin
        current_state <= next_state;
        f_reg <= (next_state == STATE_B) ? 1 : 0;
        g_reg <= (next_state == STATE_D || next_state == STATE_F) ? 1 : (next_state == STATE_G) ? 0 : g_reg;
        
        case (current_state)
            STATE_A: begin
                // Do nothing
            end
            STATE_B: begin
                // Do nothing
            end
            STATE_C: begin
                // Monitor x for sequence 1, 0, 1
                if (x_sequence == 2'b11 && x == 1'b1) begin
                    x_sequence <= 0;
                end else if (x_sequence == 2'b10 && x == 1'b0) begin
                    x_sequence <= 2'b11;
                end else if (x_sequence == 2'b01 && x == 1'b1) begin
                    x_sequence <= 2'b10;
                end else if (x_sequence == 2'b00 && x == 1'b1) begin
                    x_sequence <= 2'b01;
                end else begin
                    x_sequence <= 0;
                end
            end
            STATE_D: begin
                // Set g and move to monitor y
            end
            STATE_E: begin
                // Monitor y for value 1 within at most two clock cycles
                if (y == 1'b1) begin
                    y_timer <= 0;
                end else begin
                    y_timer <= y_timer + 1;
                end
            end
            STATE_F: begin
                // Do nothing
            end
            STATE_G: begin
                // Do nothing
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        STATE_A: begin
            if (~resetn) begin
                next_state = STATE_A;
            end else begin
                next_state = STATE_B;
            end
        end
        STATE_B: begin
            next_state = STATE_C;
        end
        STATE_C: begin
            if (x_sequence == 2'b11) begin
                next_state = STATE_D;
            end else begin
                next_state = STATE_C;
            end
        end
        STATE_D: begin
            next_state = STATE_E;
        end
        STATE_E: begin
            if (y == 1'b1 || y_timer == 2) begin
                if (y == 1'b1) begin
                    next_state = STATE_F;
                end else begin
                    next_state = STATE_G;
                end
            end else begin
                next_state = STATE_E;
            end
        end
        STATE_F: begin
            next_state = STATE_F;
        end
        STATE_G: begin
            next_state = STATE_G;
        end
    endcase
end

assign f = f_reg;
assign g = g_reg;

endmodule