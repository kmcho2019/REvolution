module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define the states
enum logic [2:0] {A, B, C, D, D1, D2, E, F} state, nextState;

// Initialize state
initial state = A;

// Update state on positive clock edge
always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

// Output and next state logic
always @(*) begin
    case (state)
        A: begin
            f = 0;
            g = 0;
            nextState = resetn ? B : A;
        end
        B: begin
            f = 1;
            g = 0;
            nextState = C;
        end
        C: begin
            f = 0;
            g = 0;
            if (x) begin
                nextState = C1;
            end else begin
                nextState = C;
            end
        end
        C1: begin
            f = 0;
            g = 0;
            if (~x) begin
                nextState = C2;
            end else begin
                nextState = C;
            end
        end
        C2: begin
            f = 0;
            g = 0;
            if (x) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        D: begin
            f = 0;
            g = 1;
            nextState = D1;
        end
        D1: begin
            f = 0;
            g = 1;
            if (y) begin
                nextState = E;
            end else begin
                nextState = D2;
            end
        end
        D2: begin
            f = 0;
            g = 1;
            if (y) begin
                nextState = E;
            end else begin
                nextState = F;
            end
        end
        E: begin
            f = 0;
            g = 1;
            nextState = E;
        end
        F: begin
            f = 0;
            g = 0;
            nextState = F;
        end
        default: begin
            f = 0;
            g = 0;
            nextState = A;
        end
    endcase
end

endmodule