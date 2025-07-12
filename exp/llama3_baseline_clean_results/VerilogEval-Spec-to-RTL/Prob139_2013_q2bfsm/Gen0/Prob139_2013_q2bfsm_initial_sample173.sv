module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Enumerate the states of the FSM
enum {A, B, C, D, E, F, G, H} state, nextState;

// Counter to keep track of clock cycles while monitoring y
reg [1:0] y_count;

always @(*) begin
    // Default values
    nextState = state;
    f = 0;
    g = 0;

    case(state)
        A: begin
            if (!resetn) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        B: begin
            f = 1;
            nextState = C;
        end
        C: begin
            if (x) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        D: begin
            if (!x) begin
                nextState = E;
            end else begin
                nextState = C;
            end
        end
        E: begin
            if (x) begin
                nextState = F;
            end else begin
                nextState = C;
            end
        end
        F: begin
            g = 1;
            y_count = 0;
            if (y) begin
                nextState = G;
            end else if (y_count == 2) begin
                nextState = H;
            end else begin
                nextState = F;
            end
        end
        G: begin
            g = 1;
            nextState = G;
        end
        H: begin
            g = 0;
            nextState = H;
        end
        default: begin
            nextState = A;
        end
    endcase
end

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        y_count <= 0;
    end else begin
        state <= nextState;
        if (state == F && !y) begin
            y_count <= y_count + 1;
        end else if (state != F) begin
            y_count <= 0;
        end
    end
end

endmodule