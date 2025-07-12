module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
enum logic [2:0] {A, B, C, D, E, F} state, next_state;

// Registers to keep track of previous x values and counter for y
reg [1:0] prev_x;
reg [1:0] y_counter;

always @(*) begin
    next_state = state;
    case(state)
        A: if (!resetn) next_state = A; else next_state = B;
        B: next_state = C;
        C: begin
            if (prev_x == 2'b10 && x == 1'b1) next_state = D;
            else next_state = C;
        end
        D: begin
            if (y_counter == 2'b00 && y == 1'b1) next_state = E;
            else if (y_counter == 2'b10) next_state = F;
            else next_state = D;
        end
        E: next_state = E;
        F: next_state = F;
    endcase
end

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        prev_x <= 0;
        y_counter <= 0;
    end
    else begin
        state <= next_state;
        case(next_state)
            B: f <= 1'b1;
            default: f <= 1'b0;
        endcase
        case(next_state)
            D: begin
                g <= 1'b1;
                if (y == 1'b1) y_counter <= 0;
                else y_counter <= y_counter + 1'b1;
            end
            E: g <= 1'b1;
            F: g <= 1'b0;
            default: g <= 1'b0;
        endcase
        prev_x <= {prev_x[0], x};
    end
end

endmodule