module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define the states
enum logic [2:0] {A, B, C, D, E, F} state, next_state;

// Initialize the state
initial state = A;

// Update the state on every clock cycle
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Calculate the next state
always @(*) begin
    case (state)
        A: begin
            if (resetn) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            next_state = C;
        end
        C: begin
            if (x) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        D: begin
            if (y) begin
                next_state = E;
            end else if (x == 0 && y == 0) begin
                next_state = F;
            end else begin
                next_state = D;
            end
        end
        E: begin
            next_state = E;
        end
        F: begin
            next_state = F;
        end
    endcase
end

// Update the outputs based on the state and inputs
always @(*) begin
    case (state)
        A: begin
            f = 0;
            g = 0;
        end
        B: begin
            f = 1;
            g = 0;
        end
        C: begin
            f = 0;
            g = 0;
        end
        D: begin
            f = 0;
            g = 1;
        end
        E: begin
            f = 0;
            g = 1;
        end
        F: begin
            f = 0;
            g = 0;
        end
    endcase
end

// Monitor x for the sequence 1, 0, 1
reg x_prev, x_prev_prev;
always @(posedge clk) begin
    x_prev_prev <= x_prev;
    x_prev <= x;
    if (x_prev_prev == 1 && x_prev == 0 && x == 1) begin
        next_state = D;
    end
end

// Monitor y for a value of 1 within two clock cycles
reg y_timer;
always @(posedge clk) begin
    if (state == D) begin
        if (y) begin
            next_state = E;
        end else if (y_timer >= 2) begin
            next_state = F;
        end else begin
            y_timer <= y_timer + 1;
        end
    end else begin
        y_timer <= 0;
    end
end

endmodule