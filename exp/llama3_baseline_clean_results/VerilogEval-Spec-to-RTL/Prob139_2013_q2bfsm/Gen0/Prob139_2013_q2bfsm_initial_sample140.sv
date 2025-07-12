module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
enum {A, B, C, D, E, WaitX1, WaitX2, WaitY1} state, nextState;

// Counter for x sequence
reg [1:0] xCounter;

// Counter for y sequence
reg [1:0] yCounter;

always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        xCounter <= 0;
        yCounter <= 0;
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
                g <= 0;
            end
            WaitX1: begin
                f <= 0;
                g <= 0;
            end
            WaitX2: begin
                f <= 0;
                g <= 0;
            end
            WaitY1: begin
                f <= 0;
                g <= 1;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        A: begin
            if (resetn) begin
                nextState = B;
            end else begin
                nextState = A;
            end
        end
        B: begin
            nextState = WaitX1;
        end
        C: begin
            if (x) begin
                xCounter <= xCounter + 1;
                if (xCounter == 3) begin
                    nextState = D;
                    xCounter <= 0;
                end else begin
                    nextState = C;
                end
            end else begin
                xCounter <= 0;
                nextState = C;
            end
        end
        D: begin
            if (y) begin
                nextState = D;
            end else begin
                yCounter <= yCounter + 1;
                if (yCounter == 2) begin
                    nextState = E;
                    yCounter <= 0;
                end else begin
                    nextState = D;
                end
            end
        end
        E: begin
            nextState = E;
        end
        WaitX1: begin
            if (x) begin
                nextState = WaitX2;
                xCounter <= 1;
            end else begin
                nextState = C;
                xCounter <= 0;
            end
        end
        WaitX2: begin
            if (!x) begin
                nextState = WaitY1;
                xCounter <= 2;
            end else begin
                nextState = C;
                xCounter <= 0;
            end
        end
        WaitY1: begin
            if (x) begin
                nextState = D;
                xCounter <= 0;
            end else begin
                nextState = C;
                xCounter <= 0;
            end
        end
    endcase
end

endmodule