module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

typedef enum {A, B, C, D, E, F} state_t;
state_t current_state, next_state;

reg [1:0] x_counter;
reg [1:0] y_counter;

always @ (posedge clk or negedge resetn) begin
    if (~resetn) begin
        current_state <= A;
        f <= 0;
        g <= 0;
        x_counter <= 0;
        y_counter <= 0;
    end else begin
        current_state <= next_state;
        case (current_state)
            A: begin
                if (resetn) next_state <= B;
                else next_state <= A;
            end
            B: begin
                f <= 1;
                next_state <= C;
            end
            C: begin
                f <= 0;
                if (x_counter == 0 && x) x_counter <= x_counter + 1;
                else if (x_counter == 1 && !x) x_counter <= x_counter + 1;
                else if (x_counter == 2 && x) x_counter <= x_counter + 1;
                else if (x_counter == 3) next_state <= D;
                else x_counter <= 0;
            end
            D: begin
                g <= 1;
                y_counter <= y_counter + 1;
                if (y || y_counter == 2) next_state <= (y) ? E : F;
                else next_state <= D;
            end
            E: begin
                g <= 1;
                next_state <= E;
            end
            F: begin
                g <= 0;
                next_state <= F;
            end
        endcase
    end
end

endmodule