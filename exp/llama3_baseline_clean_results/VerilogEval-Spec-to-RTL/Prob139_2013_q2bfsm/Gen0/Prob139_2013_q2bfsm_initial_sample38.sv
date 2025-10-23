module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Enumerate states
enum logic [2:0] {A, B, C, D, E, F} state, next_state;

// Internal signal to track x sequence
reg [1:0] x_seq;
reg [1:0] y_count;

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        x_seq <= 0;
        y_count <= 0;
    end else begin
        state <= next_state;
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

always @* begin
    case (state)
        A: begin
            if (!resetn) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            next_state = C;
        end
        C: begin
            if (x_seq == 2'b101) begin
                next_state = D;
                x_seq = 0;
            end else begin
                x_seq = {x, x_seq[0]};
                next_state = C;
            end
        end
        D: begin
            y_count <= y_count + 1;
            if (y) begin
                next_state = E;
                y_count <= 0;
            end else if (y_count == 2) begin
                next_state = F;
                y_count <= 0;
            end else begin
                next_state = D;
            end
        end
        E: begin
            next_state = E;
        end
        F: begin
            next_state = F;
        end
    endcase
end

endmodule