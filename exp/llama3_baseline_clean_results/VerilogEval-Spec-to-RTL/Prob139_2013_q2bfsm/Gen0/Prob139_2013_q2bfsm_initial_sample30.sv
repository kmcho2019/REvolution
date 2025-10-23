module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

enum logic [2:0] {A, B, C, D, E, F, G, H} state, nextState;

always_ff @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
    end else begin
        state <= nextState;
        case (state)
            A: begin
                f <= 0;
                g <= 0;
            end
            B: begin
                f <= 1;
                g <= 0;
            end
            C: begin
                f <= 0;
                g <= 0;
            end
            D: begin
                f <= 0;
                g <= 0;
            end
            E: begin
                f <= 0;
                g <= 0;
            end
            F: begin
                f <= 0;
                g <= 1;
            end
            G: begin
                f <= 0;
                g <= 1;
            end
            H: begin
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

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
            if (y) begin
                nextState = G;
            end else if (!y) begin
                nextState = (state == F) ? H : F;
            end
        end
        G: begin
            nextState = G;
        end
        H: begin
            nextState = H;
        end
        default: begin
            nextState = A;
        end
    endcase
end

endmodule