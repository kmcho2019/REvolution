module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define the states of the FSM
enum logic [2:0] {A, B, C, D, E} state, next_state;

// Initialize the state to A
initial state = A;

// Counter to keep track of the number of clock cycles in state D
reg [1:0] y_counter;

// Counter to keep track of the sequence of x values
reg [1:0] x_counter;

always @(*) begin
    case (state)
        A: begin
            if (~resetn) begin
                next_state = A;
                f = 0;
                g = 0;
            end else begin
                next_state = B;
                f = 1;
                g = 0;
            end
        end
        B: begin
            next_state = C;
            f = 0;
            g = 0;
            x_counter = 0;
        end
        C: begin
            if (x_counter == 0 && x == 1) begin
                x_counter = 1;
                next_state = C;
                f = 0;
                g = 0;
            end else if (x_counter == 1 && x == 0) begin
                x_counter = 2;
                next_state = C;
                f = 0;
                g = 0;
            end else if (x_counter == 2 && x == 1) begin
                x_counter = 0;
                next_state = D;
                f = 0;
                g = 1;
                y_counter = 0;
            end else begin
                x_counter = 0;
                next_state = C;
                f = 0;
                g = 0;
            end
        end
        D: begin
            if (y == 1 || y_counter == 2) begin
                if (y == 1) begin
                    next_state = E;
                end else begin
                    next_state = C;
                end
                f = 0;
                y_counter = 0;
            end else begin
                next_state = D;
                f = 0;
                y_counter = y_counter + 1;
            end
        end
        E: begin
            next_state = E;
            f = 0;
            g = 1;
        end
        default: begin
            next_state = A;
            f = 0;
            g = 0;
        end
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule