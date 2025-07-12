module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Define the states of the FSM
enum logic [2:0] {A, SET_F, MONITOR_X, MONITOR_X1, MONITOR_X2, MONITOR_Y, G_SET, G_CLR} state, next_state;

// Counter for x sequence detection
logic [1:0] x_counter;

// Counter for y timeout
logic [1:0] y_counter;

// Initialize outputs
assign f = (state == SET_F);
assign g = (state == MONITOR_Y || state == G_SET);

always_ff @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= A;
        x_counter <= 2'b00;
        y_counter <= 2'b00;
    end else begin
        state <= next_state;
        x_counter <= x_counter + (state == MONITOR_X && x) + (state == MONITOR_X1 && ~x) + (state == MONITOR_X2 && x);
        y_counter <= (state == MONITOR_Y) ? y_counter + 1 : 0;
    end
end

always_comb begin
    next_state = state;
    case (state)
        A: begin
            if (resetn) next_state = SET_F;
        end
        SET_F: begin
            next_state = MONITOR_X;
        end
        MONITOR_X: begin
            if (x) next_state = MONITOR_X1;
        end
        MONITOR_X1: begin
            if (~x) next_state = MONITOR_X2;
            else next_state = MONITOR_X;
        end
        MONITOR_X2: begin
            if (x) next_state = MONITOR_Y;
            else next_state = MONITOR_X;
        end
        MONITOR_Y: begin
            if (y || y_counter == 2) begin
                if (y) next_state = G_SET;
                else next_state = G_CLR;
            end
        end
        G_SET, G_CLR: begin
            // Permanent states until reset
        end
    endcase
end

endmodule