module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state, next_state;
reg [1:0] x_counter, next_x_counter;
reg [1:0] y_timer, next_y_timer;

// Sequential Logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= 2'b00;
        f <= 0;
        g <= 0;
        x_counter <= 0;
        y_timer <= 0;
    end else begin
        state <= next_state;
        f <= (state == 2'b01) ? 1'b1 : 1'b0;
        g <= (state == 2'b11) ? 1'b1 : (state == 2'b10) ? 1'b0 : 1'b0;
        x_counter <= next_x_counter;
        y_timer <= next_y_timer;
    end
end

// Combinational Logic
always @(*) begin
    next_state = state;
    next_x_counter = x_counter;
    next_y_timer = y_timer;
    
    case (state)
        2'b00: begin // IDLE
            if (resetn) next_state = 2'b01;
        end
        2'b01: next_state = 2'b10; // SET_F
        2'b10: begin // MONITOR_X
            if (x) begin
                if (x_counter == 2'b11) next_state = 2'b11;
                else next_x_counter = x_counter + 1;
            end else next_x_counter = 0;
        end
        2'b11: begin // MONITOR_Y
            if (y) next_y_timer = 0;
            else if (y_timer < 2) next_y_timer = y_timer + 1;
            else next_state = 2'b10; // Reset g after 2 cycles if y is not 1
        end
    endcase
end

endmodule