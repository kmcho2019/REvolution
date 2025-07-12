module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Enum for states
enum logic [2:0] {A, B, C, D, E, F} state, nextState;

// Initialize state to A
initial state = A;

// Sequential logic
always_ff @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
    end else begin
        state <= nextState;
        if (state == B) begin
            f <= 1;
        end else begin
            f <= 0;
        end
    end
end

// Combinational logic
always_comb begin
    case (state)
        A: begin
            if (resetn) begin
                nextState = B;
            end else begin
                nextState = A;
            end
        end
        B: begin
            nextState = C;
        end
        C: begin
            static logic [1:0] x_prev = 2'b00;
            x_prev = {x_prev[0], x};
            if (x_prev == 2'b101) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        D: begin
            static logic [1:0] y_count = 2'b00;
            if (y) begin
                nextState = E;
            end else begin
                y_count = y_count + 1;
                if (y_count == 2) begin
                    nextState = F;
                end else begin
                    nextState = D;
                end
            end
            g = 1;
        end
        E: begin
            nextState = E;
            g = 1;
        end
        F: begin
            nextState = F;
            g = 0;
        end
        default: begin
            nextState = A;
        end
    endcase
end

endmodule