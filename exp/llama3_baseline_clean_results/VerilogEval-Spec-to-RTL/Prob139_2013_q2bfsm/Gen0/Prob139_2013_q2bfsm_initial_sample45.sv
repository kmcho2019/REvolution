module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

enum logic [2:0] {A, B, C, D, E, F} state, nextState;

logic [1:0] xSeqCounter; // Counter for x sequence
logic [1:0] yTimer;      // Timer for y input after g is set

always_ff @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        xSeqCounter <= 0;
        yTimer <= 0;
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
                g <= 1;
            end
            E: begin
                f <= 0;
                g <= 1;
            end
            F: begin
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

always_comb begin
    case (state)
        A: begin
            if (!resetn) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        B: begin
            nextState = C;
        end
        C: begin
            if (xSeqCounter == 0 && x == 1) begin
                xSeqCounter = 1;
                nextState = C;
            end else if (xSeqCounter == 1 && x == 0) begin
                xSeqCounter = 2;
                nextState = C;
            end else if (xSeqCounter == 2 && x == 1) begin
                xSeqCounter = 0;
                nextState = D;
            end else begin
                xSeqCounter = (x == 1) ? 1 : 0;
                nextState = C;
            end
        end
        D: begin
            if (y == 1 || yTimer == 2) begin
                if (y == 1) begin
                    nextState = E;
                end else begin
                    nextState = F;
                end
            end else begin
                yTimer += 1;
                nextState = D;
            end
        end
        E: begin
            nextState = E;
        end
        F: begin
            nextState = F;
        end
    endcase
end

endmodule