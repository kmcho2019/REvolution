module TopModule(
    input  logic clk,
    input  logic resetn,
    input  logic x,
    input  logic y,
    output logic f,
    output logic g
);

enum logic [2:0] {A, B, C, D, E, F} state, nextState;

logic [1:0] x_counter;
logic [1:0] y_counter;

always_ff @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        x_counter <= 0;
        y_counter <= 0;
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
        x_counter <= (state == C && x) ? x_counter + 1 : (state == C && !x) ? 0 : x_counter;
        y_counter <= (state == D && y) ? 0 : (state == D && !y) ? y_counter + 1 : y_counter;
    end
end

always_comb begin
    case (state)
        A: nextState = (resetn) ? B : A;
        B: nextState = C;
        C: begin
            if (x_counter == 3) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        D: begin
            if (y_counter == 2) begin
                nextState = F;
            end else if (y) begin
                nextState = E;
            end else begin
                nextState = D;
            end
        end
        E: nextState = E;
        F: nextState = F;
    endcase
end

endmodule