module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define the states
enum logic [2:0] {A, B, C, D, E, F, G, H, I} state, next_state;

always @(*) begin
    case (state)
        A: begin
            if (~resetn) next_state = A;
            else next_state = B;
        end
        B: begin
            next_state = C;
        end
        C: begin
            if (x) next_state = D;
            else next_state = C;
        end
        D: begin
            if (~x) next_state = E;
            else next_state = C;
        end
        E: begin
            if (x) next_state = F;
            else next_state = C;
        end
        F: begin
            next_state = G;
        end
        G: begin
            if (y) next_state = H;
            else if (x) next_state = C; // reset sequence detection
            else next_state = I;
        end
        H: begin
            next_state = H;
        end
        I: begin
            next_state = I;
        end
        default: next_state = A;
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        case (state)
            B: f <= 1;
            default: f <= 0;
        endcase
        case (state)
            F, H: g <= 1;
            I: g <= 0;
            default: g <= g;
        endcase
    end
end

endmodule