module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

enum logic [2:0] {A, B, C, D, E, F} state, next_state;

logic [1:0] x_count;
logic [1:0] y_count;

always_ff @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
    end
    else begin
        case (state)
            A: begin
                if (~resetn) begin
                    state <= A;
                end
                else begin
                    state <= B;
                    f <= 1;
                end
            end
            B: begin
                state <= C;
                f <= 0;
            end
            C: begin
                if (x) begin
                    x_count <= x_count + 1;
                end
                else begin
                    x_count <= 0;
                end
                if (x_count == 3'b101) begin
                    state <= D;
                end
            end
            D: begin
                g <= 1;
                y_count <= y_count + 1;
                if (y) begin
                    state <= E;
                end
                else if (y_count == 2) begin
                    state <= F;
                end
            end
            E: begin
                g <= 1;
                state <= E;
            end
            F: begin
                g <= 0;
                state <= F;
            end
            default: begin
                state <= A;
            end
        endcase
    end
end

endmodule