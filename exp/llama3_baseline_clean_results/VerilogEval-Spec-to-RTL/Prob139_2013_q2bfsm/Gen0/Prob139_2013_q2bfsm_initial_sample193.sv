module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

parameter A = 4'b0000;
parameter B = 4'b0001;
parameter C = 4'b0010;
parameter D = 4'b0011;
parameter E = 4'b0100;
parameter F = 4'b0101;

reg [3:0] state, next_state;
reg [1:0] x_counter, next_x_counter;
reg [1:0] y_counter, next_y_counter;

always @(*) begin
    case(state)
        A: begin
            if (!resetn) begin
                next_state = A;
                next_x_counter = 0;
                next_y_counter = 0;
                f = 0;
                g = 0;
            end else begin
                next_state = B;
                next_x_counter = 0;
                next_y_counter = 0;
                f = 1;
                g = 0;
            end
        end
        B: begin
            next_state = C;
            if (x) begin
                next_x_counter = 1;
            end else begin
                next_x_counter = 0;
            end
            next_y_counter = 0;
            f = 0;
            g = 0;
        end
        C: begin
            if (x) begin
                if (x_counter == 2'b10) begin // x_counter represents the state of x sequence: 00 - no sequence, 01 - first 1, 10 - 1,0
                    next_x_counter = 0;
                    next_state = D;
                    g = 1;
                end else if (x_counter == 2'b01) begin // First 1 detected
                    next_x_counter = 2'b10; // 1,0 sequence started
                end else if (x_counter == 2'b00) begin // No sequence detected yet
                    next_x_counter = 2'b01; // First 1 detected
                end else begin
                    next_x_counter = 0; // Reset counter if sequence fails
                end
            end else if (x_counter == 2'b01) begin // If x is 0 after the first 1, reset counter
                next_x_counter = 0;
            end else if (x_counter == 2'b10) begin // If x is 0 after 1,0, it means we have 1,0,0, so reset counter
                next_x_counter = 0;
            end else begin
                next_x_counter = 0; // No sequence, keep counter at 0
            end
            next_y_counter = 0;
            next_state = C;
            f = 0;
            g = 0;
        end
        D: begin
            if (y) begin
                next_state = E;
                next_x_counter = 0;
                next_y_counter = 0;
                g = 1;
            end else begin
                if (y_counter == 2'b10) begin // Two clock cycles have passed without y = 1
                    next_state = F;
                    next_x_counter = 0;
                    next_y_counter = 0;
                    g = 0;
                end else begin
                    next_y_counter = y_counter + 1;
                    next_state = D;
                    next_x_counter = 0;
                    g = 1;
                end
            end
            f = 0;
        end
        E: begin
            next_state = E;
            next_x_counter = 0;
            next_y_counter = 0;
            f = 0;
            g = 1;
        end
        F: begin
            next_state = F;
            next_x_counter = 0;
            next_y_counter = 0;
            f = 0;
            g = 0;
        end
        default: begin
            next_state = A;
            next_x_counter = 0;
            next_y_counter = 0;
            f = 0;
            g = 0;
        end
    endcase
end

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        x_counter <= 0;
        y_counter <= 0;
    end else begin
        state <= next_state;
        x_counter <= next_x_counter;
        y_counter <= next_y_counter;
    end
end

endmodule