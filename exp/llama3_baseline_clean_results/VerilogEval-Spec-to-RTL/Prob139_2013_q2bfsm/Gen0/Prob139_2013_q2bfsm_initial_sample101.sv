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

// Internal signals
logic [1:0] x_sequence;
logic [1:0] y_counter;
logic g_internal;

always_ff @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g_internal <= 0;
        x_sequence <= 0;
        y_counter <= 0;
    end else begin
        state <= nextState;
        case(state)
            A: begin
                f <= 0;
                g_internal <= 0;
            end
            B: begin
                f <= 1;
            end
            default: begin
                f <= 0;
            end
        endcase
    end
end

always_comb begin
    case(state)
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
            if (x_sequence == 3'b101) begin
                nextState = D;
            end else begin
                nextState = C;
            end
            // Monitor x for sequence
            if (x) begin
                x_sequence = {x_sequence[0], 1};
            end else begin
                x_sequence = {x_sequence[0], 0};
            end
        end
        D: begin
            nextState = E;
        end
        E: begin
            if (y_counter < 2 && y) begin
                nextState = E; // Stay in E if y becomes 1 within 2 cycles
            end else if (y_counter == 2) begin
                nextState = F; // Move to F if y doesn't become 1 within 2 cycles
            end else begin
                nextState = E; // Otherwise, continue to the next cycle
            end
            y_counter <= y_counter + 1;
        end
        F: begin
            nextState = F; // Stay in F permanently
        end
        default: begin
            nextState = A;
        end
    endcase
end

assign g = (state == D || state == E) ? 1'b1 : g_internal;

endmodule