module TopModule (
    input         clk,
    input         resetn,
    input         x,
    input         y,
    output reg    f,
    output reg    g
);

// Define states
enum {A, B, C, D, E, F} state, next_state;

// Counter for monitoring y
reg [1:0] y_counter;

// Counter for monitoring x sequence
reg [1:0] x_counter;

always @(*) begin
    case (state)
        A: begin
            if (~resetn) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            next_state = C;
        end
        C: begin
            if (x) begin
                if (x_counter == 0) begin
                    x_counter = 1;
                end else if (x_counter == 1 && ~x) begin
                    x_counter = 2;
                end else if (x_counter == 2 && x) begin
                    next_state = D;
                    x_counter = 0;
                end else begin
                    x_counter = 0;
                end
            end else if (x_counter == 1) begin
                x_counter = 0;
            end
            next_state = C;
        end
        D: begin
            if (y || y_counter == 2) begin
                if (y) begin
                    next_state = E;
                end else begin
                    next_state = F;
                end
            end else begin
                y_counter = y_counter + 1;
            end
            next_state = D;
        end
        E: begin
            next_state = E;
        end
        F: begin
            next_state = F;
        end
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        x_counter <= 0;
        y_counter <= 0;
    end else begin
        state <= next_state;
        case (state)
            B: f <= 1;
            default: f <= 0;
        endcase
        case (state)
            D, E: g <= 1;
            default: g <= 0;
        endcase
    end
end

endmodule