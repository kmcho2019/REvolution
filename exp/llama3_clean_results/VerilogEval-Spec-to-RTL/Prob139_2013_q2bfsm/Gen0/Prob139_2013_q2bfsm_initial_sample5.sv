module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state, next_state;

// Define counter for state C
reg [1:0] x_counter;

// Define counter for state D
reg [1:0] y_counter;

// Define a flag to detect the sequence 1, 0, 1 in state C
reg seq_detected;

always @(*) begin
    // Defaults
    next_state = state;
    f = 0;
    g = 0;
    seq_detected = 0;

    case(state)
        A: begin
            if (~resetn) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end

        B: begin
            f = 1;
            next_state = C;
            x_counter = 0;
        end

        C: begin
            case(x_counter)
                0: begin
                    if (x) begin
                        x_counter = x_counter + 1;
                    end
                end
                1: begin
                    if (~x) begin
                        x_counter = x_counter + 1;
                    end else begin
                        x_counter = 0;
                    end
                end
                2: begin
                    if (x) begin
                        next_state = D;
                        y_counter = 0;
                        g = 1;
                    end else begin
                        x_counter = 0;
                    end
                end
            endcase
        end

        D: begin
            g = 1;
            if (y) begin
                next_state = E;
            end else begin
                y_counter = y_counter + 1;
                if (y_counter == 2) begin
                    next_state = F;
                end
            end
        end

        E: begin
            g = 1;
        end

        F: begin
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