module TopModule(
    input         clk,
    input         reset,
    input         w,
    output         z
);

enum logic [2:0] {A, B, C, D, E, F} currentState, nextState;

always_ff @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

always_comb begin
    case (currentState)
        A: begin
            if (w) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        B: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        C: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = E;
            end
        end
        D: begin
            if (w) begin
                nextState = A;
            end else begin
                nextState = F;
            end
        end
        E: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = E;
            end
        end
        F: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        default: begin
            nextState = A;
        end
    endcase
end

always_comb begin
    case (currentState)
        A, B, C, D: begin
            z = 0;
        end
        E, F: begin
            z = 1;
        end
        default: begin
            z = 0;
        end
    endcase
end

endmodule