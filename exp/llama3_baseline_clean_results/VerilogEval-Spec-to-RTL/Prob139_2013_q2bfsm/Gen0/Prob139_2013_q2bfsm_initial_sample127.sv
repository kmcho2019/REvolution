module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Enumerate states
enum logic [2:0] {
    A = 3'b001, // initial state, reset
    B = 3'b010, // set f to 1
    C = 3'b011, // monitor x
    D = 3'b100, // wait for y
    E = 3'b101  // g set permanently
} state, next_state;

logic [1:0] x_count;
logic [1:0] y_count;
logic g_set;

always_ff @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
        g_set <= 0;
    end else begin
        case (state)
            A: begin
                state <= B;
                f <= 0;
                g <= 0;
                x_count <= 0;
                y_count <= 0;
                g_set <= 0;
            end
            B: begin
                state <= C;
                f <= 1;
                g <= 0;
                x_count <= 0;
                y_count <= 0;
                g_set <= 0;
            end
            C: begin
                if (x == 1 && x_count == 0) begin
                    x_count <= x_count + 1;
                end else if (x == 0 && x_count == 1) begin
                    x_count <= x_count + 1;
                end else if (x == 1 && x_count == 2) begin
                    state <= D;
                    x_count <= 0;
                end else begin
                    x_count <= 0;
                end
                f <= 0;
                g <= 0;
                y_count <= 0;
                g_set <= 0;
            end
            D: begin
                g <= 1;
                y_count <= y_count + 1;
                if (y == 1 || y_count == 2) begin
                    if (y == 1) begin
                        g_set <= 1;
                    end
                    state <= E;
                end
                f <= 0;
                x_count <= 0;
            end
            E: begin
                g <= g_set;
                f <= 0;
                x_count <= 0;
                y_count <= 0;
            end
            default: begin
                state <= A;
                f <= 0;
                g <= 0;
                x_count <= 0;
                y_count <= 0;
                g_set <= 0;
            end
        endcase
    end
end

endmodule