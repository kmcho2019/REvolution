module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
enum logic [2:0] {A, B, C1, C2, C3, D, D1, D2} state, nextState;

always @(posedge clk) begin
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
            C1: begin
                f <= 0;
                g <= 0;
            end
            C2: begin
                f <= 0;
                g <= 0;
            end
            C3: begin
                f <= 0;
                g <= 0;
            end
            D: begin
                f <= 0;
                g <= 1;
            end
            D1: begin
                f <= 0;
                g <= 1;
            end
            D2: begin
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
            nextState = C1;
        end
        C1: begin
            if (x) begin
                nextState = C2;
            end else begin
                nextState = C1;
            end
        end
        C2: begin
            if (!x) begin
                nextState = C3;
            end else begin
                nextState = C1;
            end
        end
        C3: begin
            if (x) begin
                nextState = D;
            end else begin
                nextState = C1;
            end
        end
        D: begin
            nextState = D1;
        end
        D1: begin
            if (y) begin
                nextState = D2;
            end else begin
                nextState = D2;
            end
        end
        D2: begin
            if (y) begin
                nextState = D2;
            end else begin
                nextState = D2;
            end
        end
    endcase
end

endmodule