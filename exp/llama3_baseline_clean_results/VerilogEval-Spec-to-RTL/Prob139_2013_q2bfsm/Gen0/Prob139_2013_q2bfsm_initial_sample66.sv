module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

typedef enum logic [2:0] {
    A,
    B,
    C,
    D,
    E
} state_t;

state_t state;
reg [1:0] x_count;
reg [1:0] y_count;

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
    end else begin
        case (state)
            A: begin
                if (resetn) begin
                    state <= B;
                    f <= 1;
                    g <= 0;
                end else begin
                    state <= A;
                    f <= 0;
                    g <= 0;
                end
            end
            B: begin
                state <= C;
                f <= 0;
            end
            C: begin
                if (x == 1 && x_count == 0) begin
                    x_count <= x_count + 1;
                end else if (x == 0 && x_count == 1) begin
                    x_count <= x_count + 1;
                end else if (x == 1 && x_count == 2) begin
                    x_count <= 0;
                    state <= D;
                    g <= 1;
                end else begin
                    x_count <= 0;
                end
            end
            D: begin
                if (y == 1 || y_count == 2) begin
                    if (y == 1) begin
                        y_count <= 0;
                    end else begin
                        state <= E;
                        g <= 0;
                    end
                end else begin
                    y_count <= y_count + 1;
                end
            end
            E: begin
                // Do nothing, stay in this state
            end
        endcase
    end
end

endmodule