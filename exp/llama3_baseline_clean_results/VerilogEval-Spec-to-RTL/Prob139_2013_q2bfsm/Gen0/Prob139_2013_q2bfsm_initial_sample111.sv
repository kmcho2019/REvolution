module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

// Define the states
enum {A, B, C, D, E} current_state, next_state;

// Variables to keep track of the sequence of x inputs
reg [2:0] x_sequence;

// Variable to keep track of the number of clock cycles since g was set to 1
reg [1:0] y_counter;

always @(*) begin
    case (current_state)
        A: begin
            if (!resetn) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            next_state = C;
            f = 1;
        end
        C: begin
            f = 0;
            x_sequence = {x_sequence[1:0], x};
            if (x_sequence == 5) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        D: begin
            g = 1;
            y_counter = y_counter + 1;
            if (y) begin
                next_state = D;
                y_counter = 0;
            end else if (y_counter == 3) begin
                next_state = E;
            end else begin
                next_state = D;
            end
        end
        E: begin
            g = 0;
            next_state = E;
        end
        default: next_state = A;
    endcase
end

always @(posedge clk) begin
    if (!resetn) begin
        current_state <= A;
        f <= 0;
        g <= 0;
        x_sequence <= 0;
        y_counter <= 0;
    end else begin
        current_state <= next_state;
    end
end

endmodule